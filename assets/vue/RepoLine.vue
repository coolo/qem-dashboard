<template lang="html">
  <tr>
    <td>
      <div>{{ name }}</div>
      <div class="text-left">
        <button type="button" class="btn btn-primary btn-sm" @click="triggerModal">
          <span class="badge badge-primary">
            {{ incident_number }}
          </span>
          Incidents
        </button>
      </div>
    </td>
    <td>
      <ul class="summary-list">
        <li v-for="result in repo.summaries" :result="result" :key="result.name">
          <result-summary :result="result" />
        </li>
      </ul>
    </td>
  </tr>
</template>

<script>
import ResultSummaryComponent from './ResultSummary.vue';
import jQuery from 'jquery';

export default {
  name: 'RepoLineComponent',
  components: {'result-summary': ResultSummaryComponent},
  props: {repo: {type: Object, required: true}, name: {type: String, required: true}},
  computed: {
    incident_number: function () {
      return this.repo.incidents.length;
    }
  },
  methods: {
    triggerModal: function () {
      const dialog = this.$root.$refs.incidentsDialog;
      dialog.title = this.name;
      dialog.incidents = this.repo.incidents;
      jQuery('#update-incidents').modal('show');
      console.log(this.repo);
    }
  }
};
</script>
