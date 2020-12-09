import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { NbAuthService, NbAuthToken } from '@nebular/auth';
import { tap } from 'rxjs/operators';

@Injectable()
export class AuthGuard implements CanActivate {

    constructor(private authService: NbAuthService, private router: Router) {
      this.authService.onTokenChange().subscribe((token: NbAuthToken) => {
        if(!token || !token.isValid()) 
        {
          this.router.navigate(['/auth/login']);
        }
      });
    }

  canActivate() {
    return this.authService.isAuthenticated()
      .pipe(
        tap(authenticated => {
          if (!authenticated) {
            this.router.navigate(['auth/login']);
          }
        }),
      );
  }
}