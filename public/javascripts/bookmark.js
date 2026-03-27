// Bookmark toggle
function toggleBookmark(blogId, button) {
  var token = document.querySelector('meta[name="csrf-token"]');
  var tokenValue = token ? token.getAttribute('content') : '';
  fetch('/bookmark/toggle', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': tokenValue
    },
    body: JSON.stringify({blogId: blogId, authenticityToken: document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || ''})
  })
  .then(response => response.json())
  .then(data => {
    if (data.bookmarked) {
      button.textContent = '\u2605 Bookmarked';
      button.classList.add('bookmarked');
    } else {
      button.textContent = '\u2606 Bookmark';
      button.classList.remove('bookmarked');
    }
  });
}