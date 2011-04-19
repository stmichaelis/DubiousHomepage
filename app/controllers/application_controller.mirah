import dubious.*
import java.util.Random
import java.util.Map
import java.util.Locale
import javax.servlet.http.*

import com.google.appengine.api.memcache.*

class ApplicationController < ActionController

      def initialize
      	  @visibility_class = ""
	  @margin_class = ""
	  @page_background = [
	  		   "Amrum_Duenen.jpg",
			   "Amrum_Leuchtturm.jpg",
			   "Amrum_Sonnenuntergang.jpg",
			   ]
	  @random_generator = Random.new
	  @background_index = -1

	  @memcache = MemcacheServiceFactory.getMemcacheService()
          @lang = "en"
      end

      # Detect preferred language
      def index
        locales = params.request.getLocales();
        while (locales.hasMoreElements())
          locale = Locale(locales.nextElement());
          if (locale.getLanguage().equals("de"))
            @lang = "de"
            break
          end
          if (locale.getLanguage().equals("en"))
            @lang = "en"
            break
          end
        end
        sep = "/";
        if (params.controller.endsWith("/"))
          sep ="";
        end
        # Redirect conserving background parameter
        bparam = params.get("b")
        bparam = bparam != null ? "?b="+bparam : ""
        redirect_to "#{params.controller}#{sep}#{@lang}#{bparam}";
      end

      $Override
      def action_request(request:HttpServletRequest, method:String) returns Object
        result = super(request, method);
        # Method not found? Try our own language dependend
        if (Object(Integer.valueOf(404)).equals(result))
          if (params.action.equals('en') || params.action.equals('de'))
            @lang = params.action
            return show
          end
        end
        return result
      end


protected

      def lang
        @lang
      end

      def get_visibility_class
      	  @visibility_class
      end

      def set_visibility_class(s:String)
      	  @visibility_class = s
      end

      def get_margin_class
      	  @margin_class
      end

      def set_margin_class(s:String)
      	  @margin_class = s
      end

      def lang_version
        @lang_version
      end

      def lang_contact
        @lang_contact
      end

      def lang_profile
        @lang_profile
      end

      def lang_topics
        @lang_topics
      end

      def lang_changelink
        @lang_changelink
      end

      def set_german:void
        @lang_version = "English Version"
        @lang_contact = "Kontakt"
        @lang_profile = "Profil"
        @lang_topics = ["Topic A", "Topic B", "Topic C", "Topic D", "Topic E"]
        @lang_changelink = "#{params.controller}/en#{get_background_parameter}"
      end

      def set_english:void
        @lang_version = "Deutsche Version"
        @lang_contact = "Contact"
        @lang_profile = "Profile"
        @lang_topics = ["Topic A", "Topic B", "Topic C", "Topic D", "Topic E"]
        @lang_changelink = "#{params.controller}/de#{get_background_parameter}"
      end

      def generate_background_index(params:Params)
          if @memcache.contains("page_background_index")
            @background_index = Integer(@memcache.get("page_background_index")).intValue()
          end
          if params.get('b')
            @background_index = Integer.parseInt(params.get('b'))
          end
          if (@background_index < 0)
            @background_index = @random_generator.nextInt(@page_background.size)
            @memcache.put("page_background_index", Integer.new(@background_index), Expiration.byDeltaSeconds(60*30))
          end
      end

      def get_background_index
        if (@background_index < 0)
          return 0
        end	
	@background_index
      end

      def get_background_parameter
	return "?b="+get_background_index
      end

      def get_background:String
	  if (@background_index < 0)
	    return ""
	  end
      	  String(@page_background.get(@background_index))
      end

end
