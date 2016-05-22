require 'yaml' unless defined?(YAML)
require 'transmission_api'
require 'pirata'

# The main TorrentialDownpour driver
module TorrentialDownpour
  extend self

  WATCHLIST = File.expand_path("~/.torrential_downpour/watchlist.yml")
  CONFIG    = File.expand_path("~/.torrential_downpour/config.yml")

  # Loads configuration and sets up API client instances
  # This is invoked only when configuration changes
  def setup
    @watchlist = YAML.load_file(WATCHLIST)
    @config = YAML.load_file(CONFIG)

    @transmission_api_client = TransmissionApi::Client.new(
      :url => @config['transmission_api_client']['url'],
      :username => @config['transmission_api_client']['username'],
      :password => @config['transmission_api_client']['password']
    )
  end

  # The main routine
  def start
    begin
      @collection = @transmission_api_client.all
    rescue
      raise "Unable to connect to Transmission API. Check config.yml."
    end

    # Iterate on each show; build results
    @wanted = []
    @watchlist.each do |item|

      # Sanity checks for each watchlist item
      raise "Watchlist is missing required 'term' parameter!" unless item['term']
      raise "Watchlist term must be 6 characters or greater!" unless item['term'].length >= 6
      @only_newer = [true, false].include?(item['only_newer']) ? item['only_newer'] : true
      @fetch_limit = item['fetch_limit'].is_a?(Integer) ? item['fetch_limit'] : 5

      # Search, group, sort, and filter
      torrents = search_torrents(item['term'])
      results = group_sort_and_filter(item, torrents)

      @wanted.concat results
    end

    puts "Requesting #{@wanted.size} torrent files"
    puts @wanted.map(&:title)
  end

  # Searches torrents by given search term
  def search_torrents(term)
    # Search for torrents of the show, newest first
    puts "Querying torrents for search term: #{term}"
    query = Pirata::Search.new(term, Pirata::Sort::SEEDERS, [Pirata::Category::VIDEO])
    torrents = query.results

    # If we have multiple pages with seeders, keep searching
    if query.multipage? && torrents.last.seeders > 0
      pages = query.pages < 10 ? query.pages : 10
      puts "Parsing up to #{pages} pages of results..."
      # Iterate all teh pages
      2.upto(pages) do |p|
        results = query.search_page(p)
        torrents << results

        # Stop searching if last page results contains torrents without seeders
        break if results.last.seeders == 0
      end
    end
    torrents.flatten!
  end

  #
  def group_sort_and_filter(item, torrents)
    # Filter out non-episodes; Group by episode
    begin
      groups = torrents.select { |t| t.title =~ item['pattern'] }.group_by { |t| t.title.match(item['pattern'])[:episode] }
    rescue
      raise "Error parsing regular expression for term: #{item['term']}.  Pattern must contain a named capture 'episode'"
    end

    puts "Got results..."
    groups.each do |e,t|
      puts "-> #{e}:"
      t.each { |t| puts "---> #{t.title} (#{t.seeders} seeders)" }
    end

    # Sort by highest number of seeders
    sorted = {}
    groups.each do |episode,torrents| 
      sorted[episode] = torrents.sort { |a,b| a.seeders <=> b.seeders }.last
    end
    sorted = Hash[sorted.sort].values

    # Build set of existing torrents so they can be skipped
    existing = []
    @collection.each do |c|
      sorted.delete_if do |t|
        if c['name'] == t.title
          puts "Skipping known torrent: #{t.title}"
          existing << t
          true
        else
          false
        end
      end
    end

    # Skip torrents older than the latest existing episode
    if @only_newer && !existing.empty?
      latest_episode = existing.map { |t| t.title.match(item['pattern'])[:episode] }.last
      sorted.delete_if do |t|
        if t.title.match(item['pattern'])[:episode] < latest_episode
          puts "Skipping torrent older than #{latest_episode}: #{t.title}"
          true
        else
          false
        end
      end
    end

    sorted.first(@fetch_limit)
  end

end
