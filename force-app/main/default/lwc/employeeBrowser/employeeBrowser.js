import { LightningElement,wire } from 'lwc';
import getEmployees from '@salesforce/apex/EmployeeBrowser.getEmployees';
import createProjectAssignment from '@salesforce/apex/EmployeeBrowser.createProjectAssignment';

export default class EmployeeBrowser extends LightningElement {
    employee = [];
    selectedProjectSkillId = '';
    selectedProjectId = '';
    selectedEmployeeId = '';
    
    
    @wire(getEmployees, { projectId: "$selectedProjectId", projectSkillId:"$selectedProjectSkillId"}) employees;

    @wire(createProjectAssignment, { projectId: "$selectedProjectId", projectSkillId: "$selectedProjectSkillId", employeeId: "$selectedemployeeId"}) projectAssignment;

    handleFilterChange(event) {
        this.selectedProjectSkillId = event.detail.projectSkillId;  
        this.selectedProjectId = event.detail.projectId;
    }
    handleClick(){
        createProjectAssignment({
            projectId: this.selectedProjectId,
            projectSkillId: this.selectedProjectSkillId,
            employeeId: this.selectedEmployeeId
        }).then(result=>{
            this.message = 'Project Assigned';
        }).catch(error=>{
            this.message = 'Error Assigning project';
        });

    }
    handleEmployeeSelected(event) {
        this.selectedEmployeeId = event.detail.employeeId;
    }

}