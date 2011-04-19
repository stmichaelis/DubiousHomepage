/* Indicates first time page is loaded without Ajax.
   Avoids execution of history popstate. */
var initial_page_load = true;

$(document).ready(function(){
    /* Navigation Click function */
    $("nav ul li a").click(function(e) {
	
	e.preventDefault();
	
	/* "this" points to the clicked tab hyperlink: */
	var element = $(this);

	anim_and_update(element);

	if(window.history.pushState){
	    /* Remember old state */
	    window.history.pushState(element.attr('href'), document.title, element.attr('href'));
	}
	
    });
    /* History back (popstate) function*/
    if(window.history.pushState){
	window.onpopstate = function (e) { 
	    if (initial_page_load){
		initial_page_load = false;
		return;
	    }
	    if (e.state){ 
		var element = null;
		$("nav ul li a").each(function() {
		    if ($(this).attr('href') == e.state) {element = $(this);}
		});
		if (element != null){
		    anim_and_update(element);
		}
	    }
	}
    }
    /* Remember current state of non-ajax-loaded page*/
    if(window.history.pushState){
	$("nav ul li a").each(function() {
	    if ($(this).is(".active")) {
		window.history.replaceState($(this).attr('href'), document.title, $(this).attr('href')); 
	    }
	});
    }
});

/* Animates page boxes on leaving or arriving background page */
function anim_and_update(element){
    /* If it is currently active, return false and exit: */
    // if(element.find('.active').length) return false;
    
    /* For special background page move elements in or out */
    if (element.attr("href").search("background") >= 0){
	$("#profilepic").slideUp(2000);
	$("#contact_data").slideUp(2000);
	$("#main").animate({marginTop: "380px"}, 2000, function(){update_page(element)});
    } else if ($('.active').attr('href').search("background") >= 0){
	// Remove hidden classes
	$('.invisible').removeClass('invisible');

	$("#profilepic").slideDown(2000);
	$("#contact_data").slideDown(2000);
	$("#main").animate({marginTop: "10px"}, 2000, function(){update_page(element)});
    } else {
	update_page(element);
    }
}

/* Updates the page through calling Ajax or using cache data. */
function update_page(element){
    /* Setting new tab active */
    $("nav ul li a").each(function() {
	$(this).removeClass("active");	
    });
    element.addClass("active");

    /* Checking whether the AJAX fetched page has been cached: */
    if(!element.data('cache'))
    {	
	/* If no cache is present, show the gif preloader and run an AJAX request: */
	$('#contentHolder').html('<img src="images/ajax_preloader.gif" width="64" height="64" class="preloader" />');
	$.get(element.attr("href"),function(msg){
	    replace_content(msg);
	    
	    /* After page was received, add it to the cache for the current hyperlink: */
	    if (element.html().search("Home") < 0){
		element.data('cache', msg);
	    }
	});
    }
    else {
	replace_content(element.data('cache'));
    }

}

/* Replace page elements. */
function replace_content(msg){
    var res = $(msg.match(/<body>([\s\S]*)<\/body>/)[1]);
    $('#contentHolder').html(res.find('#contentHolder').html());

    /* Update Document title */
    var new_title = msg.match(/<title>(.*)<\/title>/);
    if (new_title){
	document.title = new_title[1];
    }

    /* Replace language link */
    $(".flag").attr("href", res.find(".flag").attr("href"));
    
    /* Change background image if necessary */
    if ($("nav ul li a").eq(1).attr("href") != res.find("nav ul li a").eq(1).attr("href")){
	// Very ugly hack, may break in case of changes to the html structure
	var bimage = msg.match(/background-image:(.*\.jpg\));\">/);
	if (bimage){
	    $("#container").css("backgroundImage", bimage[1]);
	    // Replace Nav-Links
	    $("nav ul li a").each(function(index) {
		$(this).attr("href", res.find("nav ul li a").eq(index).attr("href"));
	    });
	}
    }

    /* Hyphenate main content */
    Hyphenator.run();
}
