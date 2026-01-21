
function formatNumber(input) {
  let value = input.value.replace(/,/g, ''); 
  if (value === '' || isNaN(value)) return; 

  let isNegative = false;
  if (value.startsWith('-')) {
    isNegative = true;
    value = value.substring(1);
  }

  let [intPart, decPart] = value.split('.');

  if (intPart.length > 3) {
    let last3 = intPart.slice(-3);
    let rest = intPart.slice(0, -3);
    if (rest !== '') last3 = ',' + last3;
    intPart = rest.replace(/\B(?=(\d{3})+(?!\d))/g, ',') + last3;
  }

  if (decPart !== undefined) {
    decPart = decPart.substring(0, 2);
  }

  input.value =
    (isNegative ? '-' : '') + (decPart !== undefined ? intPart + '.' + decPart : intPart);
}

function validateNumber(event, item) {
  var charCode = event.which ? event.which : event.keyCode;

  if ([8, 46, 37, 39].includes(charCode)) return;

  if (charCode >= 48 && charCode <= 57) return;

  if (charCode === 46) {
    if (item.value.includes(".")) {
      event.preventDefault(); 
    }
    return;
  }

  if (charCode === 45) { // "-"
    if (item.selectionStart !== 0 || item.value.includes('-')) {
      event.preventDefault();
    }
    return;
  }

  event.preventDefault();
  var errorMsg = "Please enter a valid number.";
  item.focus();
  item.setCustomValidity(errorMsg);
  item.reportValidity();
  setTimeout(function () {
    item.setCustomValidity("");
    item.reportValidity();
  }, 1000);
}

if (typeof $s === 'function') {
  const original_s = $s;
  window.$s = function(pItem, pValue) {
    original_s(pItem, pValue);
    const elem = document.getElementById(pItem);
    if (elem && (elem.tagName === 'INPUT' && (elem.type === 'number' || elem.classList.contains('apex-item-number')))) {
      formatNumber(elem);
    }
  };
}

if (window.apex && typeof apex.item === 'function') {
  const originalApexItem = apex.item;
  apex.item = function(pItem) {
    const itemObj = originalApexItem(pItem);
    if (itemObj && typeof itemObj.setValue === 'function' && !itemObj._formatted) {
      const originalSetValue = itemObj.setValue;
      itemObj.setValue = function(pValue, pDisplayValue, pSuppressChangeEvent) {
        const result = originalSetValue.call(this, pValue, pDisplayValue, pSuppressChangeEvent);
        const elem = document.getElementById(pItem);
        if (elem && (elem.tagName === 'INPUT' && (elem.type === 'number' || elem.classList.contains('apex-item-number')))) {
          formatNumber(elem);
        }
        return result;
      };
      itemObj._formatted = true;
    }
    return itemObj;
  };
  Object.keys(originalApexItem).forEach(key => {
    apex.item[key] = originalApexItem[key];
  });
}

document.querySelectorAll('input.apex-item-number, input[type="number"]').forEach(item => {

  if (item.hasAttribute('maxlength')) {
    item.dataset.maxDigits = item.getAttribute('maxlength');
    item.removeAttribute('maxlength');
  } else {
    item.dataset.maxDigits = null;
  }

  if (!item.value || item.value.trim() === "") {
    item.placeholder = "0";
  }

  item.addEventListener('keypress', e => validateNumber(e, item));

  item.addEventListener('keydown', e => {
    if (e.key === '.' && e.target.value.includes('.')) {
      e.preventDefault();
    }
  });

  item.addEventListener('input', e => {
    const input = e.target;
    const scrollPos = input.scrollLeft;

    const maxDigits = parseInt(input.dataset.maxDigits) || null;
    let raw = input.value.replace(/[^0-9.\-]/g, ''); // numeric chars only
    if (maxDigits && raw.replace('.', '').replace('-', '').length > maxDigits) {
      let allowed = raw.slice(0, maxDigits + (raw.includes('-') ? 1 : 0));
      input.value = allowed;
    }

    const pos = input.selectionStart || 0;
    const oldLen = input.value.length;
    formatNumber(input);
    const newLen = input.value.length;
    const newPos = pos + (newLen - oldLen);
    input.setSelectionRange(newPos, newPos);

    input.scrollLeft = scrollPos;
  });

  /*
  item.addEventListener('blur', e => {
    let input = e.target;
    let val = input.value.replace(/,/g, '');
    if (val && val !== '-' && val.indexOf('.') === -1) {
      input.value = val + '.00';
    }
    formatNumber(input);
  });
  */

  if (item.value && item.value.trim() !== '') {
    formatNumber(item);
  }
});

document.querySelectorAll('[data-number="true"]').forEach(el => {
  if (el.tagName !== 'INPUT' && el.tagName !== 'TEXTAREA') {
    let val = el.innerText.replace(/,/g, '');
    if (!val || val.trim() === "") {
      el.innerText = "0.00";
    } else if (!isNaN(val)) {
      el.innerText = parseFloat(val).toFixed(2);
      let fakeInput = { value: el.innerText };
      formatNumber(fakeInput);
      el.innerText = fakeInput.value;
    }
  }
});
