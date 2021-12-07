<template>
  <li v-bind:group-id="groupId" data-toggle="tooltip" data-placement="left" v-bind:title="title">
    <result-summary v-bind:result="result"></result-summary>
  </li>
</template>

<script>
import ResultSummaryComponent from './ResultSummary.vue';

export default {
  name: 'BlockedIncidentUpdResultComponent',
  components: {'result-summary': ResultSummaryComponent},
  props: ['result', 'groupId', 'groupFlavors'],
  computed: {
    title: function () {
      if (this.groupFlavors) {
        return 'Aggregate: ' + this.result.linkinfo.version;
      } else {
        return 'Aggregate: ' + this.result.linkinfo.flavor + '-' + this.result.linkinfo.version;
      }
    }
  }
};
</script>
