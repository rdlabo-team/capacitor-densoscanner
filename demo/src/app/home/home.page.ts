import { Component, OnDestroy, OnInit } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel } from '@ionic/angular/standalone';
import { DensoScanner } from '@rdlabo/capacitor-densoscanner';
import { DensoScannerEvent, DensoScannerPolarization, DensoScannerTriggerMode } from '../../../../src';
import { PluginListenerHandle } from '@capacitor/core';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel],
})
export class HomePage implements OnInit, OnDestroy {
  listenerHandles: PluginListenerHandle[] = [];
  constructor() {}

  async ngOnInit() {
    this.listenerHandles.push(
      await DensoScanner.addListener(DensoScannerEvent.OnScannerStatusChanged, (event) => {
        console.log(event);
      }),
    );
    this.listenerHandles.push(
      await DensoScanner.addListener(DensoScannerEvent.ReadData, (event) => {
        console.log(event);
      }),
    );
  }

  ngOnDestroy() {
    this.listenerHandles.forEach((listenerHandle) => listenerHandle.remove());
  }

  attach() {
    DensoScanner.attach();
  }

  detach() {
    DensoScanner.detach();
  }

  pullData() {
    DensoScanner.pullData();
  }

  openInventory() {
    DensoScanner.openInventory();
  }

  close() {
    DensoScanner.close();
  }

  async getSettings() {
    const settings = await DensoScanner.getSettings();
    console.dir(settings);
  }

  setSettings() {
    DensoScanner.setSettings({
      triggerMode: DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
      powerLevelRead: 30,
      session: 0,
      polarization: DensoScannerPolarization.POLARIZATION_BOTH,
    });
  }
}
