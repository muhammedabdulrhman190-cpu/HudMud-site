// Gallery images array
const galleryImages = [
    'https://img.itch.zone/aW1hZ2UvNDUzNjY0OC8yNzA4MTUyMS5wbmc=/347x500/KUUkdb.png',
    'https://img.itch.zone/aW1hZ2UvNDUzNjY0OC8yNzA4MTUyNS5wbmc=/347x500/T3k8Db.png',
    'https://img.itch.zone/aW1hZ2UvNDUzNjY0OC8yNzA4MTUyMy5wbmc=/347x500/dtU6Ec.png',
    'https://img.itch.zone/aW1hZ2UvNDUzNjY0OC8yNzA4MTUyMi5wbmc=/347x500/gUwtos.png'
];

let currentImageIndex = 0;

// Open modal with lightbox
function openModal(index) {
    currentImageIndex = index;
    const modal = document.getElementById('lightboxModal');
    const modalImg = document.getElementById('modalImage');
    const caption = document.getElementById('imageCaption');
    
    modal.style.display = 'block';
    modalImg.src = galleryImages[currentImageIndex];
    caption.textContent = `Screenshot ${currentImageIndex + 1} of ${galleryImages.length}`;
    
    // Prevent body scroll when modal is open
    document.body.style.overflow = 'hidden';
}

// Close modal
function closeModal() {
    const modal = document.getElementById('lightboxModal');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Change image in modal
function changeImage(direction) {
    currentImageIndex += direction;
    
    if (currentImageIndex >= galleryImages.length) {
        currentImageIndex = 0;
    }
    if (currentImageIndex < 0) {
        currentImageIndex = galleryImages.length - 1;
    }
    
    const modalImg = document.getElementById('modalImage');
    const caption = document.getElementById('imageCaption');
    
    modalImg.style.opacity = '0';
    setTimeout(() => {
        modalImg.src = galleryImages[currentImageIndex];
        modalImg.style.opacity = '1';
    }, 200);
    
    caption.textContent = `Screenshot ${currentImageIndex + 1} of ${galleryImages.length}`;
}

// Close modal with Escape key
document.addEventListener('keydown', function(event) {
    const modal = document.getElementById('lightboxModal');
    if (modal.style.display === 'block') {
        if (event.key === 'Escape') {
            closeModal();
        } else if (event.key === 'ArrowLeft') {
            changeImage(-1);
        } else if (event.key === 'ArrowRight') {
            changeImage(1);
        }
    }
});

// Close modal when clicking outside the image
document.getElementById('lightboxModal')?.addEventListener('click', function(event) {
    if (event.target === this) {
        closeModal();
    }
});