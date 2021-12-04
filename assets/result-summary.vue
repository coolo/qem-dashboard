<template>
  <a v-if="result_failed > 0" v-bind:href="result_link" class="btn btn-danger" target="_blank">
     {{ result.name }} <span class="badge badge-light">{{ result_failed }}/{{ total }}</span>
     <span class="sr-only">failed jobs</span>
  </a>
  <a v-else-if="result_stopped > 0" v-bind:href="result_link" class="btn btn-secondary" target="_blank">
    {{ result.name }} <span class="badge badge-light">{{ result_stopped }}/{{ total }}</span>
    <span class="sr-only">stopped jobs</span>
  </a>
  <a v-else-if="result_waiting > 0" v-bind:href="result_link" class="btn btn-info" target="_blank">
    {{ result.name }} <span class="badge badge-light">{{ result_waiting }}/{{ total }}</span>
    <span class="sr-only">stopped jobs</span>
  </a>
  <a v-else-if="result_passed == total" v-bind:href="result_link" class="btn btn-success" target="_blank">
    {{ result.name }} <span class="badge badge-light">{{ total }}</span>
    <span class="sr-only">passed jobs</span>
  </a>
  <a v-else>
     {{ result.name }} is problematic
  </a>
</template>

<script>
module.exports = {
  props: ['result'],
  computed: {
    result_link: function() {
      var url = "<%= $c->openqa_url->path('/tests/overview') %>";
      const searchParams = new URLSearchParams(this.result.linkinfo);
      return url + "?" + searchParams.toString();
    },
    result_stopped: function() {
      return this.result.stopped || 0;
    },
    result_passed: function() {
      return this.result.passed || 0;
    },
    result_waiting: function() {
      return this.result.waiting || 0;
    },
    result_failed: function() {
      return this.result.failed || 0;
    },
    total: function() {
      return this.result_stopped + this.result_failed + this.result_waiting + this.result_passed;
    }
  }
};
</script>
