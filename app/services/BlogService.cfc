component {
    property name="Blog"; // Inject the Blog model

    function init(blogModel) {
        variables.Blog = blogModel; // Store model
        return this;
    }

    function getAll() {
        return variables.Blog.findAll();
    }

    function getBlogById(required numeric id) {
        return variables.Blog.findOne(
            where="blog_posts.id = #arguments.id#",
            include="User, Category, PostStatus",
            options={
                sql="SELECT blog_posts.title AS blogTitle, blog_posts.content AS blogContent, 
                    blog_posts.createdat AS createdDate, 
                    users.name AS authorName, 
                    categories.name AS categoryName, 
                    post_statuses.name AS statusName 
                    FROM blog_posts 
                    INNER JOIN users ON users.id = blog_posts.userId
                    INNER JOIN categories ON categories.id = blog_posts.categoryId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId 
                    WHERE blog_posts.id = #arguments.id#"
            }
        );
    }

    function getBlogBySlug(required string slug) {
        return variables.Blog.findOne(where="slug = #arguments.slug#");
    }

    function saveBlog(required struct blogData) {
        var message = "";

        // A slug is a URL-friendly version of the post's title. 
        // It usually appears at the end of the URL and is used to identify the post in a way that's easy to read and remember.
        var slug = rereplace(lcase(blogData.title), "[^a-z0-9- ]", "", "all");
        blogData.slug = replace(slug, " ", "-", "all");

        // Start the transaction
        // transaction {
            try {
                
                // Check if the blog ID is greater than 0 (for editing an existing post)
                if (blogData.id > 0) {
                    var blog = variables.Blog.findById(blogData.id);

                    if (not isNull(blog)) {
                        // Edit the existing blog post
                        blog.title = blogData.title;
                        blog.content = blogData.content;
                        blog.categoryId = blogData.categoryId;
                        blog.statusId = blogData.statusId;
                        blog.postTypeId = blogData.postTypeId;
                        blog.slug = blogData.slug;
                        blog.updatedAt = now();
                        blog.updatedBy = 1; // Replace with logged-in user ID
                        blog.save();
                        message = "Blog post updated successfully.";
                    } else {
                        message = "Blog post not found for editing.";
                    }
                } else {
                    // Check if a blog post with the same title and category already exists
                    var existingBlog = variables.Blog.findFirst(
                        where="title = '#blogData.title#' AND categoryId = '#blogData.categoryId#' AND isDeleted = 0"
                    );

                    if (!isObject(existingBlog)) {
                        // Create a new blog post
                        var newBlog = variables.Blog.new();
                        newBlog.title = blogData.title;
                        newBlog.content = blogData.content;
                        newBlog.slug = blogData.slug;
                        newBlog.categoryId = blogData.categoryId;
                        newBlog.statusId = blogData.statusId;
                        newBlog.postTypeId = blogData.postTypeId;
                        newBlog.createdAt = now();
                        newBlog.updatedAt = now();
                        newBlog.createdBy = 1; // Replace with logged-in user ID
                        newBlog.isDeleted = false;
                        newBlog.save();

                        // Save tags if find
                        // if (structKeyExists(blogData, "posttag") && arrayLen(blogData.posttag) > 0) {
                        // }
                        
                        // // Save attachments if find
                        // if (structKeyExists(blogData, "attachment") && arrayLen(blogData.attachment) > 0) {
                        // }

                        message = "Blog post created successfully.";
                    } else {
                        message = "A blog post with the same title and category already exists.";
                    }
                }
                
                // transaction action="commit"; 
            } catch (any e) {
                
                // transaction action="rollback";
                // Catch any errors and store the message
                message = "Error: " & e.message;
            }
        // }

        // Return the message
        return message;
    }

    function updateBlog(required struct blogData) {
        return saveBlog(blogData);
    }

    function deleteBlog(required numeric id) {
        var message = "";

        try {
            var blog = variables.Blog.findById(id);

            if (not isNull(blog)) {
                blog.isDeleted = true;
                blog.updatedAt = now();
                blog.updatedBy = 1; // Replace with logged-in user ID
                blog.save();
                message = "Blog post deleted successfully.";
            } else {
                message = "Blog post not found for deletion.";
            }
        } catch (any e) {
            // Catch any errors and store the message
            message = "Error: " & e.message;
        }

        // Return the message
        return message;
    }
}
