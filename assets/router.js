import Vue from 'vue';
import Router from 'vue-router';
import BlockedComponent from './vue/Blocked.vue';

Vue.use(Router);

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      props(route) {
        const matched = route.matched;
        if (matched.length > 1) {
          return matched[1].meta;
        }
        return {};
      },
      children: [
        {
          path: '',
          name: 'home',
          component: BlockedComponent
        },
        {
          path: 'blocked',
          name: 'blocked',
          component: BlockedComponent
        },
        {
          path: 'repos',
          name: 'repos',
          component: BlockedComponent
        }
      ]
    }
  ]
});
