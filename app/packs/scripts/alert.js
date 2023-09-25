console.log("Alert closing script working...");

document.addEventListener("DOMContentLoaded", function() {
  const closeButton = document.querySelector('.alert-close');
  closeButton.addEventListener('click', function() {
    const alertMessage = this.closest('.alert');
    alertMessage.style.display = 'none';
  });
});