# -*- coding: iso-8859-1 -*-
import dubious.*
import models.*

class MotivationController < ApplicationController

      def initialize
        super
        @nav_activeclass =["", "active", "", "", ""]
      end

      def show
	  generate_background_index(params)

        if (lang.equals("de"))
          set_german
          render motivation_erb, main_erb
        else 
          set_english
          render motivation_en_erb, main_erb
        end
      end

      def_edb(motivation_erb, 'views/pages/de/motivation.html.erb')
      def_edb(motivation_en_erb, 'views/pages/en/motivation.html.erb')
      def_edb(main_erb,  'views/layouts/application.html.erb')

protected

      def set_german:void
        super()
        @page_title = "My title A"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/motivation/de"/>'
      end

      def set_english:void
        super()
        @page_title = "My title A"
        @page_description = "Metadescription"
        @link_canonical = '<link rel="canonical" href="http://example.com/motivation/en"/>'
      end
end
