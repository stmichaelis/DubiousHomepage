import dubious.*
import models.*

class ResearchController < ApplicationController
      
      def initialize
      	  super
	  @nav_activeclass =["", "", "active", "", ""]
      end

      def show
        generate_background_index(params)
        
        if (lang.equals("de"))
          set_german
          render research_erb, main_erb
        else 
          set_english
          render research_en_erb, main_erb
        end
      end

      def_edb(research_erb, 'views/pages/de/research.html.erb')
      def_edb(research_en_erb, 'views/pages/en/research.html.erb')
      def_edb(main_erb,  'views/layouts/application.html.erb')

protected

      def set_german:void
        super()
        @page_title = "My title B"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/research/de"/>'
      end

      def set_english:void
        super()
        @page_title = "My title B"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/research/en"/>'
      end
end
