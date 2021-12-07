import './sass/app.scss';
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.css';
import App from './vue/App.vue';
import router from './router.js';
import $ from 'jquery';
import Vue from 'vue';

window.$ = $;

import 'timeago';

import titleMixin from './mixins/titleMixin.js';
Vue.mixin(titleMixin);

function fromNow() {
  $('.from-now').each(function () {
    var date = $(this);
    date.text($.timeago(new Date(date.text() * 1000)));
  });
}

function backToTop() {
  $(window).scroll(function () {
    if ($(this).scrollTop() > 50) {
      $('#back-to-top').fadeIn();
    } else {
      $('#back-to-top').fadeOut();
    }
  });
  $('#back-to-top').click(function () {
    $('body, html').animate({scrollTop: 0}, 800);
    return false;
  });
}

window.addEventListener('load', function () {
  new Vue({
    el: '#app',
    router,
    render: h => h(App),
    components: {App}
  });

  fromNow();
  backToTop();
  $('[data-toggle="tooltip"]').tooltip({trigger: 'hover'});
});
