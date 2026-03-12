<cfscript>
  // Place helper functions here that should be available for use in all view pages of your application.
  /**
	* Turns "My Thing" into "mything"
	*
	* @str The String
	*/
	string function $cssClassLink(str){
		return trim(replace(lcase(str), " ", "", "all"));
	}
	/**
	* Formats the Main Hint
	*
	* @str The Hint String
	*/
	string function $hintOutput(str){
		local.rv="<p>" & $backTickReplace(arguments.str) & "</p>";
		return trim(local.rv);
	}
	/**
	* Searches for ``` in hint description output and formats
	*
	* @str The String to search
	*/
	string function $backTickReplace(str){
		return ReReplaceNoCase(arguments.str, '`(.*?)`', '<code>\1</code>', "ALL");
	}

	function generateCSRFToken() {
        if (!structKeyExists(session, "csrf_token")) {
            session.csrf_token = hash(createUUID() & now());
        }
        return session.csrf_token;
    }

    function verifyCSRFToken(required string token) {
        return structKeyExists(session, "csrf_token") && token == session.csrf_token;
    }

	string function gravatarUrl(required string email, numeric size=80) {
		var emailHash = lcase(hash(lcase(trim(arguments.email)), "MD5"));
		return "https://www.gravatar.com/avatar/" & emailHash & "?s=" & arguments.size & "&d=404";
	}

	/**
	 * Extracts YouTube video ID from various YouTube URL formats
	 * Supports: https://youtube.com/watch?v=xyz, https://youtu.be/xyz, https://www.youtube.com/embed/xyz
	 */
	string function extractYouTubeId(required string url) {
		var id = "";

		// youtu.be format
		if (findNoCase("youtu.be/", arguments.url)) {
			id = listLast(arguments.url, "/");
			// Remove any query parameters
			if (findNoCase("?", id)) {
				id = listFirst(id, "?");
			}
		}
		// youtube.com/watch?v= format
		else if (findNoCase("youtube.com", arguments.url) && findNoCase("v=", arguments.url)) {
			var params = listLast(arguments.url, "?");
			var paramList = listToArray(params, "&");
			for (var param in paramList) {
				if (findNoCase("v=", param)) {
					id = listLast(param, "=");
					break;
				}
			}
		}
		// Already embed format
		else if (findNoCase("youtube.com/embed/", arguments.url)) {
			id = listLast(listFirst(arguments.url, "?"), "/");
		}

		return trim(id);
	}

	/**
	 * Detects if a URL is embeddable and returns embed HTML
	 * Supports: YouTube, Twitter
	 */
	string function getEmbedHtml(required string url, string width="100%", string height="400") {
		var embedHtml = "";
		var youtubeId = "";
		var vimeoId = "";
		var trimmedUrl = trim(arguments.url);

		// YouTube
		if (findNoCase("youtube.com", trimmedUrl) || findNoCase("youtu.be", trimmedUrl)) {
			youtubeId = extractYouTubeId(trimmedUrl);
			if (len(youtubeId)) {
				embedHtml = '<iframe width="#arguments.width#" height="#arguments.height#" src="https://www.youtube.com/embed/#youtubeId#?rel=0" frameborder="0" allowfullscreen style="max-width: 100%; margin: 1rem 0; border-radius: 0.5rem;"></iframe>';
			}
		}
		// Twitter/X
		else if (findNoCase("twitter.com", trimmedUrl) || findNoCase("x.com", trimmedUrl)) {
			embedHtml = '<blockquote class="twitter-tweet" style="margin: 1rem 0;"><a href="#trimmedUrl#"></a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>';
		}

		return embedHtml;
	}

	/**
	 * Checks if a URL is embeddable
	 */
	boolean function isEmbeddableUrl(required string url) {
		var embeddableDomains = ["youtube.com", "youtu.be", "twitter.com", "x.com"];
		var trimmedUrl = lcase(trim(arguments.url));

		for (var domain in embeddableDomains) {
			if (findNoCase(domain, trimmedUrl)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Converts plain text URLs and embeddable links into HTML
	 * For embeddable URLs (YouTube, Vimeo, etc.), creates embed iframes
	 * For other URLs, creates anchor tags
	 */
	string function embedAndAutoLink(required string content, string class="text--primary", string target="_blank") {
		var result = arguments.content;
		var urlPattern = "(https?://[^\s<""'`]+)";
		var matches = reMatch(urlPattern, result);

		// Remove duplicates
		var uniqueUrls = {};
		for (var match in matches) {
			var cleanUrl = trim(match);
			// Skip if it's already part of an href or src
			if (!findNoCase("href='#cleanUrl#", result) && !findNoCase('href="' & cleanUrl & '"', result) && !findNoCase("src='#cleanUrl#", result) && !findNoCase('src="' & cleanUrl & '"', result)) {
				uniqueUrls[cleanUrl] = cleanUrl;
			}
		}

		// Replace each unique URL
		for (var link in uniqueUrls) {
			if (isEmbeddableUrl(link)) {
				var embedCode = getEmbedHtml(link);
				if (len(embedCode)) {
					result = replace(result, link, embedCode, "all");
				}
			} else {
				// Regular link
				var linkHtml = '<a href="' & link & '" class="' & arguments.class & '" target="' & arguments.target & '">' & link & '</a>';
				result = replace(result, link, linkHtml, "all");
			}
		}

		return result;
	}
</cfscript>
