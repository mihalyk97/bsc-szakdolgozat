import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest, HttpResponse } from "@angular/common/http";
import { Observable } from 'rxjs';
import { Injectable } from '@angular/core';
import { catchError, filter, map } from 'rxjs/operators';
import { Router } from '@angular/router';
import { NbComponentStatus, NbToastrService } from '@nebular/theme';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
    constructor(private router: Router, private toastrService: NbToastrService) { }
    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        return next.handle(req).pipe(
            catchError((error: HttpErrorResponse) => {
                if (error && error.status === 401 && !req.url.endsWith("login")) {
                  this.router.navigate(['/auth/login']);
                } 
                console.log(error.error.reason);
                this.showToast("danger",error.status.toString(),error.error.reason);
                throw(error);
              })
          );
    }

    private showToast(type: NbComponentStatus, title: string, body: string) {
      const config = {
        status: type,
        duration: 2000,
      };
      const titleContent = title ? `${title}` : '';
  
      this.toastrService.show(
        body,
        `Hiba: ${titleContent}`,
        config);
    }
  }