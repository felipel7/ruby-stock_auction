window.addEventListener('load', () => {
  const toggle = document.querySelector('.menu__item.admin');
  const adminMenu = document.querySelector('.admin.menu');

  toggle.addEventListener('click', () => {
    adminMenu.classList.toggle('show');
  });
});
