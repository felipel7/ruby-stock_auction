import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['countdown'];

  connect() {
    this.secondsUntilEnd = this.countdownTarget.dataset.secondsUntilEndValue;

    const now = new Date().getTime();
    this.endTime = new Date(now + Math.abs(this.secondsUntilEnd) * 1000);

    this.countdown = setInterval(this.countdown.bind(this), 500);
  }

  countdown() {
    const now = new Date();
    const secondsRemaining = (this.endTime - now) / 1000;

    if (secondsRemaining <= 0) {
      clearInterval(this.countdown);
      this.countdownTarget.classList.remove('countdown');
      this.countdownTarget.innerHTML = '';
      location.reload();
      return;
    }

    const secondsPerDay = 86400;
    const secondsPerHour = 3600;
    const secondsPerMinute = 60;

    const isCountdownPositive = this.secondsUntilEnd >= 0;
    const label = isCountdownPositive ? 'Termina em:' : 'Começa em:';

    const days = Math.floor(Math.abs(secondsRemaining) / secondsPerDay)
      .toString()
      .padStart(2, '0');
    const hours = Math.floor(
      (Math.abs(secondsRemaining) % secondsPerDay) / secondsPerHour
    )
      .toString()
      .padStart(2, '0');
    const minutes = Math.floor(
      (Math.abs(secondsRemaining) % secondsPerHour) / secondsPerMinute
    )
      .toString()
      .padStart(2, '0');
    const seconds = Math.floor(Math.abs(secondsRemaining) % secondsPerMinute)
      .toString()
      .padStart(2, '0');

    const countdownHTML = `
      <div class="icon__wrapper">
        <i class="fa fa-clock-o"></i>
      </div>
      <div class="text__wrapper">
        <p class="text">${label}</p>
        <strong class="time">${`${days}D ${hours} : ${minutes} : ${seconds}`}</strong>
      </div>
    `;

    this.countdownTarget.innerHTML = countdownHTML;
  }
}
