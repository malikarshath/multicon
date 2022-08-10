import { LightningElement,wire } from 'lwc';
import getEmployees from '@salesforce/apex/EmployeeBrowser.getEmployees';

export default class EmployeeBrowser extends LightningElement {
    employee = [];
    selectedProjectSkillId = '';
    selectedProjectId = '';
    
    
    @wire(getEmployees, { projectId: "$selectedProjectId", projectSkillId:"$selectedProjectSkillId"}) employees;

    handleFilterChange(event) {
        this.selectedProjectSkillId = event.detail.projectSkillId;
        this.selectedProjectId = event.detail.projectId;
    }

}