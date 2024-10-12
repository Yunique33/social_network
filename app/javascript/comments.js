document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.reply-link').forEach(function(element) {
        element.addEventListener('click', function(e) {
            e.preventDefault();
            var commentId = this.getAttribute('data-comment-id');
            var replyForm = document.getElementById('reply-form-' + commentId);
            replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
        });
    });
});