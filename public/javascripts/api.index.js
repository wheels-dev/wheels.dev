$(document).ready(function(){

	checkForUrlHash();

	$("#searchclear").hide();

	let infiniteScrollEnabled = true;
	// Version switcher
	$("#versioncontrol").on("change", function(e){
		var version=$(this).val();
		var oldHash=window.location.hash;
		window.location="/api/v" + version + oldHash;
	});

	$(window).on('hashchange',function(){
		filterByFunctionName(location.hash.slice(1));
	});

	$(".section").on("click", function(e){
		infiniteScrollEnabled = false;
		filterBySection($(this).data("section"));
		updateFunctionCount();
		e.preventDefault();
	});
	$(".category").on("click", function(e){
		infiniteScrollEnabled = false;
		filterByCategory($(this).data("section"), $(this).data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".docreset").on("click", function(e){
		$(".functiondefinition").show();
		$(".functionlink").show();
		updateFunctionCount();
		e.preventDefault();
	});

	$(".functionlink").on("click", function(e){
		infiniteScrollEnabled = false;
		filterByFunctionName($(this).data("function"));
		$(".functionlink").removeClass("active");
		$(this).addClass("active");
		updateFunctionCount();
		e.preventDefault();
	});

	$(".filtersection").on("click", function(e){
		infiniteScrollEnabled = false;
		filterBySection($(this).closest(".functiondefinition").data("section"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".filtercategory").on("click", function(e){
		infiniteScrollEnabled = false;
		var parent=$(this).closest(".functiondefinition");
		filterByCategory(parent.data("section"),parent.data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	function filterByFunctionName(name){
		$("#main").find(".functiondefinition").hide().end()
				   .find("[data-function='" + name + "']").show().end()
				   .find("#" + name).show();
		window.location.hash="#" + name;
	}
	function filterByCategory(section, category){
		$("#functionlist").find(".functionlink").hide().end()
				   .find('[data-section="' + section + '"][data-category="' + category + '"]').show();
		$("#main").find(".functiondefinition").hide().end()
				   .find('[data-section="' + section + '"][data-category="' + category + '"]').show();
	}
	function filterBySection(section){
		$("#functionlist").find(".functionlink").hide().end()
				   .find('[data-section="' + section + '"]').show();
		$("#main").find(".functiondefinition").hide().end()
				   .find('[data-section="' + section + '"]').show();
	}
	function updateFunctionCount(){
		$(".functioncount").html($("#functionlist a.functionlink:visible").length);
	}

	function checkForUrlHash(){
		var match = location.hash.match(/^#?(.*)$/)[1];
		if (match){filterByFunctionName(match);}
	}

	$("#searchclear").click(function(){
		$("#searchclear").hide();
	    $("#doc-search").val('');
		$("#functionlist a").show();
		updateFunctionCount();
	});

	// Write on keyup event of keyword input element
	$("#doc-search").keyup(function(){
		var val = $(this).val().toLowerCase();
		if( $(this).val() != "")
		{
			$('#functionlist .functionlink').each(function(){
				var text = $(this).text().toLowerCase();
				if(text.indexOf(val) != -1){
					$("#searchclear").show();
					$(this).show();
				}else{
					$(this).hide();
				}
			})
			updateFunctionCount();
		}else{
			$("#searchclear").hide();
			$("#functionlist a").show();
			updateFunctionCount();
		}
	});

	let items = $('.functiondefinition');
	let itemsPerPage = 5;
	let currentIndex = 0;
  
	// Hide all items initially
	if (!window.location.hash) {
		items.hide();
	}
	if (window.location.hash) {
		infiniteScrollEnabled = false;
	}
	// Function to show next set of items
	function showNextItems() {
		let nextItems = items.slice(currentIndex, currentIndex + itemsPerPage);
		nextItems.fadeIn(); 
		currentIndex += itemsPerPage;
	
		if (currentIndex >= items.length) {
			$(window).off('scroll', onScroll); // All items shown, stop scroll
		}
	}
  
	// Scroll handler
	function onScroll() {
		if (!infiniteScrollEnabled) return;
		if ($(window).scrollTop() + $(window).height() >= $(document).height() - 10) {
			$('#loader').show();
			setTimeout(() => {
			showNextItems();
			$('#loader').hide();
			}, 1000); // Simulate a brief delay
		}
	}
  
	// Initial load
	if (!window.location.hash) {
		showNextItems();
	}
  
	// Attach scroll event
	$(window).on('scroll', onScroll);

});
// jQuery expression for case-insensitive filter
$.extend($.expr[":"],
{
    "contains-ci": function(elem, i, match, array)
  {
    return (elem.textContent || elem.innerText || $(elem).text() || "").toLowerCase().indexOf((match[3] || "").toLowerCase()) >= 0;
  }
});

;!(function ($) {
    $.fn.classes = function (callback) {
        var classes = [];
        $.each(this, function (i, v) {
            var splitClassName = v.className.split(/\s+/);
            for (var j = 0; j < splitClassName.length; j++) {
                var className = splitClassName[j];
                if (-1 === classes.indexOf(className)) {
                    classes.push(className);
                }
            }
        });
        if ('function' === typeof callback) {
            for (var i in classes) {
                callback(classes[i]);
            }
        }
        return classes;
    };
})(jQuery);

function copyToClipboard(element) {
    const container = element.closest("div").parentElement; // Get the outer container
    const copiedText = container.querySelector("span"); // Find "Copied!" text

    let codeBlock = "";

    // First, check for <code> inside <pre>
    let preCodeElement = container.querySelector("pre code");

    if (preCodeElement) {
        codeBlock = preCodeElement.innerText.trim();
    } else {
        // If <code> inside <pre> is not found, check for <pre> alone
        let preElement = container.querySelector("pre");
        if (preElement) {
            codeBlock = preElement.innerText.trim();
        }
    }

    navigator.clipboard.writeText(codeBlock).then(() => {
        element.classList.add("d-none"); // Hide copy icon
        copiedText.classList.remove("d-none"); // Show "Copied!" text

        setTimeout(() => {
            copiedText.classList.add("d-none"); // Hide "Copied!" after 5s
            element.classList.remove("d-none"); // Show copy icon again
        }, 5000);
    }).catch(err => {
        console.error("Failed to copy text: ", err);
    });
}