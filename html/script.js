let $contextMenu = $("#context-menu");
let $menuOptions = $(".menu-options");
let hit = null;
let activeIndex = 0;
let progress = 0;
let options = [];

function openInteraction(letter, options) {
  $('body').css('display', 'block');
  let buttonLetter = letter.toUpperCase();
  $(".button-letter").text(buttonLetter);

  $menuOptions.empty();
  options.forEach(option => {
    $menuOptions.append(`<li>${option.label}</li>`);
  });
  
  $contextMenu.css("display", "flex");
  setActiveOption(activeIndex);
}

function setProgress(percentage) {
  $('.progress-bar').css('width', `${percentage}%`);
  progress = percentage;
}

function resetProgress() {
  $('.progress-bar').css('width', '0%');
  progress = 0;
  return true;
}

function setActiveOption(index) {
  $menuOptions.children().removeClass('active');
  $menuOptions.children().eq(index).addClass('active');
}

function closeInteraction() {
  if (resetProgress()) $("#context-menu").hide();
}

window.addEventListener('message', function(event) {
  switch(event.data.action) {
    case "open":
      activeIndex = 0
      options = null;
      $('body').css('display', 'block');
    break;
    case "update":
      options = event.data.options
      openInteraction(event.data.key, event.data.options);
    break;
    case "close":
      activeIndex = 0;
      closeInteraction()
    break;
    case "up":
      if ($contextMenu.is(':visible') && options.length) {
        activeIndex = (activeIndex - 1 + options.length) % options.length;
        setActiveOption(activeIndex);
      }
    break;
    case "down":
      if ($contextMenu.is(':visible') && options.length) {
        activeIndex = (activeIndex + 1) % options.length;
        setActiveOption(activeIndex);
      }
    break;
    case 'keydown':
      if (hit) return;
      setProgress(event.data.progress);
      if (progress >= 100) {
        hit = true;
        $.post(`https://interactions/enter`, JSON.stringify({index: activeIndex + 1}));
        closeInteraction();
        setTimeout(() => {
          hit = null;
        }, 1000);
      }
    break;
    case "keyup":
      resetProgress();
    break;
  }
});

