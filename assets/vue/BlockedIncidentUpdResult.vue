<template>
  <li :group-id="groupId" data-toggle="tooltip" data-placement="left" :title="title">
    <result-summary :result="result" />
  </li>
</template>

<script>
import ResultSummaryComponent from './ResultSummary.vue';

export default {
  name: 'BlockedIncidentUpdResultComponent',
  components: {'result-summary': ResultSummaryComponent},
  props: {result: {type: Object, required: true}, groupId: {type: Number, required: true}, groupFlavors: Boolean},
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
