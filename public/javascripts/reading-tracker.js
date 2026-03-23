// Simple reading tracker
class ReadingTracker {
  constructor(blogId) {
    this.blogId = blogId;
    this.trackingInterval = null;
    var tokenEl = document.querySelector('meta[name="csrf-token"]');
    this.csrfToken = tokenEl ? tokenEl.getAttribute('content') : '';
    this.init();
  }

  init() {
    // Track visit immediately
    this.trackRead();

    // Track every 30 seconds
    this.trackingInterval = setInterval(() => {
      this.trackRead();
    }, 30000);

    // Mark complete on scroll to bottom
    window.addEventListener('scroll', () => {
      if (this.isScrolledToBottom()) {
        this.markComplete();
      }
    });
  }

  trackRead() {
    fetch('/reading-history/track', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': this.csrfToken
      },
      body: JSON.stringify({blogId: this.blogId, authenticityToken: this.csrfToken})
    });
  }

  markComplete() {
    fetch('/reading-history/complete', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': this.csrfToken
      },
      body: JSON.stringify({blogId: this.blogId, authenticityToken: this.csrfToken})
    });
    clearInterval(this.trackingInterval);
  }

  isScrolledToBottom() {
    return (window.innerHeight + window.scrollY) >= document.body.offsetHeight - 100;
  }
}

// Auto-init on blog pages
document.addEventListener('DOMContentLoaded', () => {
  const blogId = document.querySelector('[data-blog-id]')?.dataset.blogId;
  if (blogId) {
    new ReadingTracker(blogId);
  }
});