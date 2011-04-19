# -*- coding: iso-8859-1 -*-
import dubious.*
import models.*

class TechnologyController < ApplicationController

      def initialize
        super
        @nav_activeclass =["", "", "", "active", ""]
      end

      def show
	  generate_background_index(params)

        if (lang.equals("de"))
          set_german
          render technology_erb, main_erb
        else 
          set_english
          render technology_en_erb, main_erb
        end
      end

      def_edb(technology_erb, 'views/pages/de/technology.html.erb')
      def_edb(technology_en_erb, 'views/pages/en/technology.html.erb')
      def_edb(main_erb,  'views/layouts/application.html.erb')

protected

      def set_german:void
        super()
        @page_title = "My title D"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/technology/de"/>'
      end

      def set_english:void
        super()
        @page_title = "My title D"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/technology/en"/>'
      end
end
