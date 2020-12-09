import { ModuleWithProviders, NgModule, Optional, SkipSelf } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NbAuthJWTToken, NbAuthModule, NbDummyAuthStrategy, NbPasswordAuthStrategy } from '@nebular/auth';
import { NbSecurityModule, NbRoleProvider } from '@nebular/security';
import { of as observableOf } from 'rxjs';

import { throwIfAlreadyLoaded } from './module-import-guard';
import {
  AnalyticsService,
  LayoutService,
  PlayerService,
  SeoService,
  StateService,
} from './utils';

const socialLinks = [
  {
    url: 'https://github.com/akveo/nebular',
    target: '_blank',
    icon: 'github',
  },
  {
    url: 'https://www.facebook.com/akveo/',
    target: '_blank',
    icon: 'facebook',
  },
  {
    url: 'https://twitter.com/akveo_inc',
    target: '_blank',
    icon: 'twitter',
  },
];

export class NbSimpleRoleProvider extends NbRoleProvider {
  getRole() {
    // here you could provide any role based on any auth flow
    return observableOf('guest');
  }
}

export const NB_CORE_PROVIDERS = [
  NbAuthModule.forRoot({
    strategies: [
      NbPasswordAuthStrategy.setup({
        name: 'email',
        token: {
          class: NbAuthJWTToken,
          key: 'token',
        },
        baseEndpoint: '',
        login: {
          endpoint: '/admin/login',
          redirect: {
            success: '/pages/overview/',
            failure: null,
          },
          defaultErrors: ['Email és/vagy jelszó nem megfelelő. Próbálja újra!'],
          defaultMessages: ['Sikeresen bejelentkezett.'],
        },
        requestPass: {
          endpoint: '/admin/forgottenPassword',
          method: 'post',
          redirect: {
            success: '/auth/reset-password',
            failure: null,
          },
          defaultErrors: ['Próbálja újra.'],
          defaultMessages: ['A visszaállításhoz szükséges kódot eküldtük a megadott email címre..'],
        },
        resetPass: {
          endpoint: '/admin/newPassword',
          method: 'post',
          redirect: {
            success: '/auth/login',
            failure: null,
          },
          defaultErrors: ['Próbálja újra.'],
          defaultMessages: ['A jelszó sikeresen megváltozatatva.'],
        }
      }),
    ],
    forms: {
      validation: {
        password: {
          minLenght: 6,
          maxLength: 12,
          required: true
        },
        email: {
          required: true
        }
      }
    },
  }).providers,

  NbSecurityModule.forRoot({
    accessControl: {
      guest: {
        view: '*',
      },
      user: {
        parent: 'guest',
        create: '*',
        edit: '*',
        remove: '*',
      },
    },
  }).providers,

  {
    provide: NbRoleProvider, useClass: NbSimpleRoleProvider,
  },
  AnalyticsService,
  LayoutService,
  PlayerService,
  SeoService,
  StateService,
];

@NgModule({
  imports: [
    CommonModule,
  ],
  exports: [
    NbAuthModule,
  ],
  declarations: [],
})
export class CoreModule {
  constructor(@Optional() @SkipSelf() parentModule: CoreModule) {
    throwIfAlreadyLoaded(parentModule, 'CoreModule');
  }

  static forRoot(): ModuleWithProviders<CoreModule> {
    return {
      ngModule: CoreModule,
      providers: [
        ...NB_CORE_PROVIDERS,
      ],
    };
  }
}
