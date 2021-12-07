import './sass/app.scss';
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.css';
import router from './router.js';
import App from './vue/App.vue';
import $ from 'jquery';
import Vue from 'vue';

window.$ = $;

import 'timeago';

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
  /* global global_openqa_url, global_config_status, global_mojo_status_url, global_obs_url, global_smelt_url */
  /* eslint no-undef: "error"*/
  Vue.prototype.$openqa_url = global_openqa_url;
  Vue.prototype.$smelt_url = global_smelt_url;
  Vue.prototype.$obs_url = global_obs_url;
  Vue.prototype.$config_status = global_config_status;
  if (Vue.prototype.$config_status) Vue.prototype.$mojo_status_url = global_mojo_status_url;
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
