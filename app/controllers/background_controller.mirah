# -*- coding: utf-8 -*-
import dubious.*
import models.*
import java.io.File
import java.io.BufferedReader
import java.io.FileInputStream
import java.io.InputStreamReader

class BackgroundController < ApplicationController

      def initialize
	super
	@nav_activeclass =["", "", "", "", "active"]
	set_visibility_class("invisible")
	set_margin_class("topmargin")	
	@link_canonical = ""
      end

      def show
        generate_background_index(params)

        if (lang.equals("de"))
          set_german
        else 
          set_english
        end
        
        pic_name = get_background
        node = File.new(System.getProperty('user.dir') + "/app/views/pages/"+lang+"/background/" +
	       	 	pic_name.substring(0,pic_name.length-4) + ".html")
        
        text = node.isFile ? read(node) : ''
        
        @page_background_text = "<p>"+text+"</p>"+@page_comment
        
        if (lang.equals("de"))
          render background_erb, main_erb
        else 
          render background_en_erb, main_erb
        end
      	  
      end

      def_edb(background_erb, 'views/pages/de/background.html.erb')
      def_edb(background_en_erb, 'views/pages/en/background.html.erb')
      def_edb(main_erb,  'views/layouts/application.html.erb')

protected

      def set_german:void
        super()
        @page_title = "My title C"
	@page_description = "Metadescription"
        @page_comment = "<p>This sentence appears on each page.</p>"
      end

      def set_english:void
        super()
        @page_title = "My title C"
        @page_description = "Metadescription"
        @page_comment = "<p>This sentence appears on each page.</p>"
      end

private

     def read(file:File)
       # bytes = byte[int(file.length)]
       result = ""
       input = BufferedReader.new(InputStreamReader.new(FileInputStream.new(file), "ISO-8859-1"))
       begin
         while ((str = input.readLine()) != null)
           result = result.concat(str);
         end
       ensure
        input.close
       end
       return result
     end
end
