component {
    property name="Blog"; // Inject the Blog model

     function init(blogModel) {
        variables.Blog = blogModel; // Store model
        return this;
    }

    function getAllBlogs() {
        return variables.Blog.findAll();
    }
    
    function getBlogById(required numeric id) {
        return variables.Blog.findOne(where="id = #arguments.id#");
    }
    
    function getBlogBySlug(required string slug) {
        return variables.Blog.findOne(where="slug = #arguments.slug#");
    }

    function saveBlog(required struct blogData){

        var message = "";
    
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
                    blog.postTypeId = blogData.posttypeId;
                    blog.updatedAt = now();
                    blog.updatedBy = 1; // Replace with logged-in user ID
                    blog.save();
                    message = "Blog post updated successfully.";
                } else {
                    message = "Blog post not found for editing.";
                }
            } else {
                
                // Check if a blog post with the same title and category already exists
                var existingBlog = variables.Blog.findFirst(where="title = '#blogData.title#'
                AND categoryId = '#blogData.categoryId#'
                AND isDeleted = 'false'");

                if (existingBlog eq false) {
                    // Create a new blog post
                    var newBlog = variables.Blog.new();
                    newBlog.title = blogData.title;
                    newBlog.content = blogData.content;
                    newBlog.categoryId = blogData.categoryId;
                    newBlog.statusId = blogData.statusId;
                    newBlog.postTypeId = blogData.posttypeId;
                    newBlog.createdAt = now();
                    newBlog.updatedAt = now();
                    newBlog.createdBy = 1; // Replace with logged-in user ID
                    newBlog.isDeleted = false;
                    newBlog.save();
                    message = "Blog post created successfully.";
                } else {
                    message = "A blog post with the same title and category already exists.";
                }
            }
        } catch (any e) {
            // Catch any errors and store the message
            message = "Error: " & e.message;
        }
    
        // Return the message
        return message;
    }
    
}
