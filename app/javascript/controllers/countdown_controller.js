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
     <div class="flex flex-col items-center mt-4">
        <p class="text-gray-300 uppercase text-sm opacity-60 mb-3">${label}</p>
        <div class="flex items-center justify-center space-x-4 mt-4">
          <div class="flex flex-col items-center px-4 border-r dark:border-gray-700">
            <span class="text-xl lg:text-2xl text-gray-200">${days}</span>
            <span class="text-gray-400 mt-2">D</span>
          </div>
          <div class="flex flex-col items-center px-4 border-r dark:border-gray-700">
            <span class="text-xl lg:text-2xl text-gray-200">${hours}</span>
            <span class="text-gray-400 mt-2">Hrs</span>
          </div>
          <div class="flex flex-col items-center px-4 border-r dark:border-gray-700">
            <span class="text-xl lg:text-2xl text-gray-200">${minutes}</span>
            <span class="text-gray-400 mt-2">Min</span>
          </div>
          <div class="flex flex-col items-center px-4">
            <span class="text-xl lg:text-2xl text-gray-200">${seconds}</span>
            <span class="text-gray-400 mt-2">Sec</span>
          </div>
        </div>
      </div>
    `;

    this.countdownTarget.innerHTML = countdownHTML;
  }
}
