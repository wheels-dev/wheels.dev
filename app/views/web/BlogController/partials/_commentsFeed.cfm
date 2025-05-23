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
    <title>Comments on Wheels.dev Blog</title>
    <atom:link href="#application.env.application_host#/blog/comments/feed/" rel="self" type="application/rss+xml" />
    <link>#application.env.application_host#/blog</link>
    <description><![CDATA[Latest comments on the Wheels blog]]></description>
    <language>en-US</language>
    <sy:updatePeriod>hourly</sy:updatePeriod>
    <sy:updateFrequency>1</sy:updateFrequency>
    <generator>#application.env.application_host#</generator>

    <cfloop array="#comments#" item="comment">
        <cfsilent>
            <cfset blogSlug = comment.Blog.slug>
            <cfset blogTitle = comment.Blog.title>
            <cfset commentBody = comment.content>
            <cfset commentDate = comment.createdAt>
            <cfset shortDescription = left(reReplace(commentBody, "<[^>]*>", "", "all"), 160)>
            <cfset commenter = structKeyExists(authorMap, comment.authorId) ? authorMap[comment.authorId].fullname : "Anonymous">
        </cfsilent>
        <item>
            <title><![CDATA[Comment on #blogTitle# by #commenter#]]></title>
            <link>#application.env.application_host#/blog/#blogSlug#?cid=#comment.id#</link>
            <dc:creator><![CDATA[#commenter#]]></dc:creator>
            <pubDate>#dateFormat(commentDate, "ddd, dd mmm yyyy")# #timeFormat(commentDate, "HH:mm:ss")# +0000</pubDate>
            <guid isPermaLink="false">#application.env.application_host#/blog/#blogSlug#?cid=#comment.id#</guid>
            <description><![CDATA[#shortDescription#]]></description>
            <content:encoded><![CDATA[#commentBody#]]></content:encoded>
            <wfw:commentRss>#application.env.application_host#/blog/#blogSlug#</wfw:commentRss>
            <slash:comments>1</slash:comments>
        </item>
    </cfloop>
</cfoutput>
</channel>
</rss>
