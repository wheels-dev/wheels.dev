// Bookmark toggle
function toggleBookmark(blogId, button) {
  fetch('/bookmark/toggle', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({blogId: blogId})
  })
  .then(response => response.json())
  .then(data => {
    if (data.bookmarked) {
      button.innerHTML = '★ Bookmarked';
      button.classList.add('bookmarked');
    } else {
      button.innerHTML = '☆ Bookmark';
      button.classList.remove('bookmarked');
    }
  });
}