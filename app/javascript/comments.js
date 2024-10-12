document.addEventListener('turbo:load', function() {
    document.body.addEventListener('click', function(event) {
        if (event.target.classList.contains('reply-link')) {
            event.preventDefault();
            var commentId = event.target.getAttribute('data-comment-id');
            var replyForm = document.getElementById('reply-form-' + commentId);
            if (replyForm) {
                replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
            }
        }
    });
});