component {
    property name="Blog"; // Inject the Blog model

    function init(blogModel) {
        variables.Blog = blogModel; // Store model
        return this;
    }

    function getAll() {
        return variables.Blog.findAll();
    }

    function getAllBlogs() {
        return variables.Blog.findAll(
            include="User, Category, PostStatus, PostType",
            order="createdAt DESC",
            options={
                sql="SELECT blog_posts.title AS blogTitle, blog_posts.content AS blogContent, 
                    blog_posts.createdat AS createdDate, 
                    users.fullName AS authorName, 
                    categories.name AS categoryName, 
                    post_statuses.name AS statusName, 
                    post_types.name AS posttypeName 
                    FROM blog_posts 
                    INNER JOIN users ON users.id = blog_posts.userId
                    INNER JOIN categories ON categories.id = blog_posts.categoryId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId
                    INNER JOIN post_types ON post_types.id = post_types.postTypeId"
            }
        );
    }

    function getAllByDate(required numeric month, required numeric year){
        return variables.Blog.findAll(
            // where="id=1 AND title = 'test'",
            // where="MONTH(createdAt) = 3",
            // where="YEAR(createdAt) = '#val(year)#' AND MONTH(createdAt) = '#val(month)#'",
            // order="createdAt DESC",
            // include="User",
            // returnAs="query"
        );
    }
    
    // Fetch Blogs by Category
    function getAllByCategory(required numeric categoryId){
        return variables.Blog.findAll(
            where='categoryId = #val(categoryId)#',
            order="createdAt DESC",
            include="User",
            returnAs="query"
        );
    }

    function getBlogById(required numeric id) {
        return variables.Blog.findOne(
            where="blog_posts.id = #arguments.id#",
            include="User, Category, PostStatus",
            options={
                sql="SELECT blog_posts.title AS blogTitle, blog_posts.content AS blogContent, 
                    blog_posts.createdat AS createdDate, 
                    users.fullName AS authorName, 
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
        // return variables.Blog.findOne(where="slug = #arguments.slug#");
        return variables.Blog.findOne(
            where="blog_posts.slug = '#arguments.slug#'",
            include="User, Category, PostStatus",
            options={
                sql="SELECT blog_posts.title AS blogTitle, blog_posts.content AS blogContent, 
                    blog_posts.createdat AS createdDate, 
                    users.fullName AS authorName, 
                    categories.name AS categoryName, 
                    post_statuses.name AS statusName 
                    FROM blog_posts 
                    INNER JOIN users ON users.id = blog_posts.userId
                    INNER JOIN categories ON categories.id = blog_posts.categoryId
                    INNER JOIN post_statuses ON post_statuses.id = blog_posts.statusId 
                    WHERE blog_posts.slug = '#arguments.slug#'"
            }
        );
    }

    function saveBlog(required struct blogData) {
        var response = { "message": "", "blogId": 0 };
    
        // Generate slug
        var slug = rereplace(lcase(blogData.title), "[^a-z0-9- ]", "", "all");
        blogData.slug = replace(slug, " ", "-", "all");
        
        if (blogData.isdraft eq 1) {
            blogData.statusId = 1; // Draft
        } else {
            blogData.statusId = 2; // Under Review
        }
    
        try {
            // Check if the blog ID is greater than 0 (editing an existing post)
            if (structKeyExists(blogData, "id") && blogData.id > 0) {
                var blog = variables.Blog.findById(blogData.id);
    
                if (not isNull(blog)) {
                    // Update the existing blog post
                    blog.title = blogData.title;
                    blog.content = blogData.content;
                    blog.categoryId = blogData.categoryId;
                    blog.statusId = blogData.statusId;
                    blog.postTypeId = blogData.postTypeId;
                    blog.slug = blogData.slug;
                    blog.updatedAt = now();
                    blog.updatedBy = application.wo.GetSignedInUserId();
                    blog.save();
    
                    response.blogId = blog.id;
                    response.message = "Blog post updated successfully.";
                } else {
                    response.message = "Blog post not found for editing.";
                }
            } else {
                // Check if a blog post with the same title and category already exists
                var existingBlog = variables.Blog.findFirst(
                    where="title = '#blogData.title#' AND slug = '#blogData.slug#'"
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
                    newBlog.excerpt = blogData.excerpt;
                    newBlog.coverImagePath = blogData.coverImagePath;
                    newBlog.createdAt = now();
                    newBlog.updatedAt = now();
                    newBlog.createdBy = application.wo.GetSignedInUserId();
                    newBlog.save();
    
                    response.blogId = newBlog.id;
                    response.message = "Blog post created successfully.";
                } else {
                    response.message = "A blog post with the same title and category already exists.";
                }
            }
        } catch (any e) {
            response.message = "Error: " & e.message;
        }
    
        return response;
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

    function ApproveorReject(id){
        var blog = variables.Blog.findByKey(arguments.id);
        
        if (!isNull(blog)) {
            
            blog.statusid = 8; //approved
            //blog.statusid = 9; //declined
            
            if (blog.save()) {
                return {
                    success = true,
                    message = "blog status updated successfully"
                };
            } else {
                return {
                    success = false,
                    errors = blog.allErrors(),
                    message = "Failed to update blog status"
                };
            }
        }
        
        return {
            success = false,
            message = "blog not found"
        };
    }

}
