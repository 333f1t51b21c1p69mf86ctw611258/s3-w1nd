/* tslint:disable max-line-length */
import { ComponentFixture, TestBed, async, inject } from '@angular/core/testing';
import { OnInit } from '@angular/core';
import { DatePipe } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { Observable } from 'rxjs/Rx';
import { JhiDateUtils, JhiDataUtils, JhiEventManager } from 'ng-jhipster';
import { SwwebTestModule } from '../../../test.module';
import { MockActivatedRoute } from '../../../helpers/mock-route.service';
import { WorkflowDetailComponent } from '../../../../../../main/webapp/app/entities/workflow/workflow-detail.component';
import { WorkflowService } from '../../../../../../main/webapp/app/entities/workflow/workflow.service';
import { Workflow } from '../../../../../../main/webapp/app/entities/workflow/workflow.model';

describe('Component Tests', () => {

    describe('Workflow Management Detail Component', () => {
        let comp: WorkflowDetailComponent;
        let fixture: ComponentFixture<WorkflowDetailComponent>;
        let service: WorkflowService;

        beforeEach(async(() => {
            TestBed.configureTestingModule({
                imports: [SwwebTestModule],
                declarations: [WorkflowDetailComponent],
                providers: [
                    JhiDateUtils,
                    JhiDataUtils,
                    DatePipe,
                    {
                        provide: ActivatedRoute,
                        useValue: new MockActivatedRoute({id: 123})
                    },
                    WorkflowService,
                    JhiEventManager
                ]
            }).overrideTemplate(WorkflowDetailComponent, '')
            .compileComponents();
        }));

        beforeEach(() => {
            fixture = TestBed.createComponent(WorkflowDetailComponent);
            comp = fixture.componentInstance;
            service = fixture.debugElement.injector.get(WorkflowService);
        });

        describe('OnInit', () => {
            it('Should call load all on init', () => {
            // GIVEN

            spyOn(service, 'find').and.returnValue(Observable.of(new Workflow(10)));

            // WHEN
            comp.ngOnInit();

            // THEN
            expect(service.find).toHaveBeenCalledWith(123);
            expect(comp.workflow).toEqual(jasmine.objectContaining({id: 10}));
            });
        });
    });

});
