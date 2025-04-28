$(document).ready(function(){

	checkForUrlHash();

	$("#searchclear").hide();

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
		filterBySection($(this).data("section"));
		updateFunctionCount();
		e.preventDefault();
	});
	$(".category").on("click", function(e){
		filterByCategory($(this).data("section"), $(this).data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".docreset").on("click", function(e){
		$(".functiondefinition").show();
		$(".functionlink").show();
		$(".functionlink").removeClass("active text--primary fw-bold");
		$(".functionlink").addClass("text--secondary fw-normal");

		$(this).removeClass("text--secondary fw-normal");
		$(this).addClass("text--primary fw-bold");
		updateFunctionCount();
		e.preventDefault();
	});

	$(".functionlink").on("click", function(e){
		filterByFunctionName($(this).data("function"));
		$(".functionlink").removeClass("active");
		$(this).removeClass("text--secondary fw-normal");
		$(this).addClass("active text--primary fw-bold");

		$(this).siblings("a").removeClass("active text--primary fw-bold");
		$(this).siblings("a").addClass("text--secondary fw-normal");

		$(".docreset").removeClass("text--primary fw-bold");
		$(".docreset").addClass("text--secondary fw-normal");
		updateFunctionCount();
		e.preventDefault();
	});

	$(".filtersection").on("click", function(e){
		filterBySection($(this).closest(".functiondefinition").data("section"));
		updateFunctionCount();
		e.preventDefault();
	});

	$(".filtercategory").on("click", function(e){
		var parent=$(this).closest(".functiondefinition");
		filterByCategory(parent.data("section"),parent.data("category"));
		updateFunctionCount();
		e.preventDefault();
	});

	function filterByFunctionName(name){
		$("#main").find(".functiondefinition").hide().end()
				   .find("[data-function='" + name + "']").show().end()
				   .find("#" + name).show();
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

	$('.showSections').click(function(){
		$("#functionlist").addClass("d-none");
		$("#sectionContainer").removeClass("d-none");
	})

	$('.showFunctions').click(function(){
		$("#functionlist").removeClass("d-none");
		$("#sectionContainer").addClass("d-none");
		$(".functionlink").show();
		$(".functionlink").removeClass("active text--primary fw-bold");
		$(".functionlink").addClass("text--secondary fw-normal");

		$(".docreset").removeClass("text--secondary fw-normal");
		$(".docreset").addClass("text--primary fw-bold");
	})

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
document.addEventListener("htmx:beforeRequest", function(evt) {
	document.getElementById("loader").style.display = "block";
});

document.addEventListener("htmx:afterRequest", function(evt) {
	document.getElementById("loader").style.display = "none";
});

document.addEventListener("htmx:responseError", function(evt) {
	document.getElementById("loader").style.display = "none";
});

document.body.addEventListener("htmx:afterSwap", function(evt) {
	// Only scroll when full content is swapped (not for infinite scroll)
	if (evt.detail.target.id === "main") {
		// Scroll to top of the page
		window.scrollTo({ top: 0, behavior: "smooth" });
	}
});