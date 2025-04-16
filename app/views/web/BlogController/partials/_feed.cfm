<cfcontent type="application/rss+xml; charset=utf-8">
<cfheader name="Content-Type" value="application/rss+xml; charset=utf-8">
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
>
<channel>
<cfoutput>
	<title>Blog | CFWheels</title>
	<atom:link href="#application.env.application_host#/blog/feed/" rel="self" type="application/rss+xml" />
	<link>#application.env.application_host#/blog</link>
	<description><![CDATA[Build apps quickly with an organized, Ruby on Rails-inspired structure. Get up and running in no time!]]></description>
<!--- 	<lastBuildDate>#dateFormat(blogPosts[1].updatedAt, "ddd, dd mmm yyyy")# #timeFormat(blogPosts[1].updatedAt, "HH:mm:ss")# +0000</lastBuildDate> --->
	<language>en-US</language>
	<sy:updatePeriod>hourly</sy:updatePeriod>
	<sy:updateFrequency>1</sy:updateFrequency>
	<generator>#application.env.application_host#</generator>

<!--- 	<image> 
		<url>#application.env.application_host#/images/rss-icon.png</url>
		<title>#htmlEdit(blogTitle)#</title>
		<link>#application.env.application_host#/blog</link>
		<width>32</width>
		<height>32</height>
	</image>--->

	<cfloop query="#blogPosts#">
		<item>
			<title><![CDATA[#blogPosts.title#]]></title>
			<link>#application.env.application_host#/blog/#blogPosts.slug#</link>
			<dc:creator><![CDATA[#blogPosts.firstname# #blogPosts.lastname#]]></dc:creator>
			<pubDate>#dateFormat(blogPosts.updatedAt, "ddd, dd mmm yyyy")# #timeFormat(blogPosts.updatedAt, "HH:mm:ss")# +0000</pubDate>
            <cfset category = this.getCategoriesByBlogid(blogPosts.id)>
			<cfloop query="#category#">
				<category><![CDATA[#category.name#]]></category>
			</cfloop>

			<guid isPermaLink="false">#application.env.application_host#/blog/#blogPosts.slug#</guid>
            <cfset strippedContent = reReplace(blogPosts.content, "<[^>]*>", "", "all")>
            <cfset shortDescription = left(strippedContent, 160)>
            <description><![CDATA[#shortDescription#]]></description>
		</item>
	</cfloop>
</cfoutput>
</channel>
</rss>