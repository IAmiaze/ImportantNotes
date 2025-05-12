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
  if ((charCode >= 48 && charCode <= 57) || /[^a-zA-Z0-9\s.\-]/.test(event.key)) {
    event.preventDefault();
    var errorMsg = "Numeric values are not allowed here.";
    item.focus();
    item.setCustomValidity(errorMsg);
    item.reportValidity();

    // Clear the custom validity message after a short delay
    setTimeout(function() {
      item.setCustomValidity("");
      item.reportValidity();
    }, 1000); // Clear the message after 2 seconds

  } else {
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




