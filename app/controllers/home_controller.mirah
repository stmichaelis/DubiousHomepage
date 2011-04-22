import dubious.*
import models.*

class HomeController < ApplicationController
      
      def initialize
        super
        @nav_activeclass =["active", "", "", "", ""]
      end

      $Override
      def index
        r = super()
        if (lang == "en")
          # Stay here without redirect
          generate_background_index(params)
          set_english
          return render home_en_erb, main_erb
        end
        if (lang != "en")
          return r
        end
      end

      def show
        generate_background_index(params)
        if (lang.equals("de"))
          set_german
          render home_erb, main_erb
        else 
          set_english
          render home_en_erb, main_erb
        end
        
      end

      def_edb(home_erb, 'views/pages/de/home.html.erb')
      def_edb(home_en_erb, 'views/pages/en/home.html.erb')
      def_edb(main_erb, 'views/layouts/application.html.erb')


protected

      def set_german:void
        super()
        @page_title = "Home"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/de"/>'
      end

      def set_english:void
        super()
        @page_title = "Home"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/"/>'
      end
end
