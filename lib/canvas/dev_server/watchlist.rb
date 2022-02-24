module Canvas
  class DevServer
    class WatchList
      def files
        Canvas::Config.get(:links)&.keys || []
      end
    end
  end
end
