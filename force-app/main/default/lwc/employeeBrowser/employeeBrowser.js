import { LightningElement,wire,track } from 'lwc';
import getEmployees from '@salesforce/apex/EmployeeBrowser.getEmployees';
import createProjectAssignment from '@salesforce/apex/EmployeeBrowser.createProjectAssignment';
import { refreshApex } from "@salesforce/apex";

export default class EmployeeBrowser extends LightningElement {
    employee = [];
    selectedProjectSkillId = '';
    selectedProjectId = '';
    selectedEmployeeId = '';
    @track choose = true;
    
    
    @wire(getEmployees, { projectId: "$selectedProjectId", projectSkillId:"$selectedProjectSkillId"}) employees;

    @wire(createProjectAssignment, { projectId: "$selectedProjectId", projectSkillId: "$selectedProjectSkillId", employeeId: "$selectedemployeeId"}) projectAssignment;

    handleFilterChange(event) {
        this.selectedProjectSkillId = event.detail.projectSkillId;  
        this.selectedProjectId = event.detail.projectId;
        if (this.selectedProjectSkillId === '') {
            this.choose = true;
        }
    }
    handleClick(){
        if (confirm("Do you want to assign!")) {
            createProjectAssignment({
                projectId: this.selectedProjectId,
                projectSkillId: this.selectedProjectSkillId,
                employeeId: this.selectedEmployeeId
            });
            alert("Project assigned");
            refreshApex(this.employees);
        } else {
            alert("Project not assigned");
        }

    }
    handleEmployeeSelected(event) {
        this.selectedEmployeeId = event.detail.employeeId;
        if (this.selectedProjectSkillId !== '' && this.selectedEmployeeId !== ''){
            this.choose = false;
        } else if (this.selectedProjectSkillId === '' || this.selectedEmployeeId === ''){
            this.choose = true;
        }
    }

}