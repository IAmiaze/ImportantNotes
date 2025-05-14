function validateOnlyText(event, item) {
  var charCode = event.which ? event.which : event.keyCode;
  var inputValue = item.value + event.key;

  if ((charCode >= 48 && charCode <= 57) || !/^[a-zA-Z0-9\s\\/]*$/.test(event.key)) {
    event.preventDefault();
    var errorMsg = "Numeric values are not allowed here.";
    item.focus();
    item.setCustomValidity(errorMsg);
    item.reportValidity();
  } else {
    if (inputValue.length === 1) {
      event.preventDefault();
      item.value = event.key.toUpperCase();
    }

    apex.message.clearErrors();
    item.setCustomValidity("");
  }
}

function validateText(event, item) {
  var charCode = event.which ? event.which : event.keyCode;
  var inputValue = item.value + event.key;

  // Block numeric and disallowed special characters except @
  if ((charCode >= 48 && charCode <= 57) || /[^a-zA-Z0-9\s.\-@]/.test(event.key)) {
    event.preventDefault();
    var errorMsg = "Numeric values are not allowed here.";
    item.focus();
    item.setCustomValidity(errorMsg);
    item.reportValidity();

    // Clear the custom validity message after a short delay
    setTimeout(function() {
      item.setCustomValidity("");
      item.reportValidity();
    }, 1000);

  } else {
    // Convert first character to uppercase
    if (inputValue.length === 1) {
      event.preventDefault();
      item.value = event.key.toUpperCase();
    }

    apex.message.clearErrors();
    item.setCustomValidity("");
  }
}

function validateNumber(event, item) {
  var charCode = event.which ? event.which : event.keyCode;
  var value = item.value;
  var inputValue = item.value + event.key;

  // Check if the input is a period (.)
  if (charCode === 46) {
    if (value.indexOf(".") !== -1) {
      // Only allow one period
      event.preventDefault();
    }
  } else if (charCode > 31 && (charCode < 48 || charCode > 57)) {
    // Prevent non-numeric input
    event.preventDefault();
    var errorMsg = "Please enter a valid number.";
    item.focus();
    item.setCustomValidity(errorMsg);
    item.reportValidity();

    // Clear the custom validity message after a short delay
    setTimeout(function() {
      item.setCustomValidity("");
      item.reportValidity();
    }, 1000); // Clear the message after 2 seconds

  } else {
    // If input is valid, clear any error messages
    if (value !== "" && isNaN(value)) {
      var errorMsg = "Please enter a valid number.";
      item.focus();
      item.setCustomValidity(errorMsg);
      item.reportValidity();

      // Clear the custom validity message after a short delay
      setTimeout(function() {
        item.setCustomValidity("");
        item.reportValidity();
      }, 1000); // Clear the message after 2 seconds
    } else {
      apex.message.clearErrors();
      item.setCustomValidity("");
    }
  }
}

//without Fraction

function  validateNumberNonFraction(event, item) {
  var charCode = event.which ? event.which : event.keyCode;
  var value = item.value;
  var inputValue = item.value + event.key;

  // Function to show custom validation message
  function showError(message) {
    item.focus();
    item.setCustomValidity(message);
    item.reportValidity();

    // Clear the custom validity message after a short delay
    setTimeout(function() {
      item.setCustomValidity("");
      item.reportValidity();
    }, 1000); // Clear the message after 1 second
  }

  // Prevent non-numeric input and periods
  if (charCode === 46 || (charCode > 31 && (charCode < 48 || charCode > 57))) {
    event.preventDefault();
    showError("Please enter a valid whole number.");
  } else {
    // If input is valid, clear any error messages
    if (value !== "" && isNaN(value)) {
      showError("Please enter a valid number.");
    } else {
      apex.message.clearErrors();
      item.setCustomValidity("");
    }
  }

 }



//Redirect to page with appId, session ,page
function redirectToPage(pAppId, pageId, pSession) {
    apex.navigation.redirect('f?p=' + pAppId + ':' + pageId + ':' + pSession);
}


//Magnifier Image

function enableImageMagnifier(selector, maxWidth = 1200, maxHeight = 1200) {
  // Add modal HTML only once
  if (!document.getElementById('image-modal')) {
    const modal = document.createElement('div');
    modal.id = 'image-modal';
    modal.style.cssText = `
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.85);
      justify-content: center;
      align-items: center;
      z-index: 9999;
    `;

    const img = document.createElement('img');
    img.id = 'modal-img';
    img.style.cssText = `
      max-width: ${maxWidth}px;
      max-height: ${maxHeight}px;
      border-radius: 2px;
      box-shadow: 0 0 10px rgba(255,255,255,0.2);
      width: 40%;
    `;

    const close = document.createElement('span');
    close.innerHTML = '&times;';
    close.style.cssText = `
      position: absolute;
      top: 20px;
      right: 30px;
      font-size: 30px;
      color: white;
      cursor: pointer;
    `;
    close.addEventListener('click', () => {
      modal.style.display = 'none';
    });

    modal.appendChild(img);
    modal.appendChild(close);
    document.body.appendChild(modal);

    // Hide modal when clicking outside image
    modal.addEventListener('click', (e) => {
      if (e.target === modal) modal.style.display = 'none';
    });
  }

  document.querySelectorAll(selector).forEach(img => {
    img.style.cursor = 'zoom-in';

    img.addEventListener('click', function () {
      const modal = document.getElementById('image-modal');
      const modalImg = document.getElementById('modal-img');
      modalImg.src = img.src;
      modal.style.display = 'flex';
    });
  });
}


//FetchImagewithKey

function fetchImage(imageKey) {
    const imageKey1 = imageKey; // Same key used in modal page
    const storedImage = localStorage.getItem(imageKey1);

    if (storedImage) {
        const imageDisplay = document.getElementById(imageKey1);
        imageDisplay.src = storedImage; // Set the src to the saved image
    } else {
        imageDisplay.innerHTML = '<span style="color: #aaa; font-size: 18px;">No Image Available</span>'; // Placeholder text
    }
}



