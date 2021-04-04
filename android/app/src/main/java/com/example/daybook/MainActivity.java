package com.example.daybook;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.os.Environment;
import android.provider.MediaStore;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.auth.api.signin.GoogleSignInAccount;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    MethodChannel.Result myresult;

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if(requestCode==100){
            if(grantResults.length>0 &&  grantResults[0]== PackageManager.PERMISSION_GRANTED  ){
                System.out.println("permistion suc");
                myresult.success(true);
            }else{
                myresult.success(false);
                System.out.println("permistion faill");
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),"daybook").setMethodCallHandler((call,result)->{
            if(call.method.equals("images")){
            
            String[] colums = {MediaStore.Images.Media.DATA,MediaStore.Images.Media.DATE_ADDED};
            final Cursor cursor = getApplicationContext().getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,colums,null,null,MediaStore.Images.Media.DATE_ADDED+" DESC");
                ArrayList<String> myresult = new ArrayList<String>(cursor.getCount());
            if(cursor.moveToFirst()){
                final int image_path_col = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                do{
myresult.add(cursor.getString(image_path_col));
                }while(cursor.moveToNext());
            }
            cursor.close();
           
             result.success(myresult);


            }else if(call.method.equals("permision")){

                if(ContextCompat.checkSelfPermission(getApplicationContext(),Manifest.permission.READ_EXTERNAL_STORAGE)== PackageManager.PERMISSION_DENIED){
                    myresult = result;
                    requestpermsion();
                    
                }else{
                    result.success(true);
                }
             

            }else if(call.method.equals("checkPermistion")){
               if(ContextCompat.checkSelfPermission(getApplicationContext(),Manifest.permission.READ_EXTERNAL_STORAGE)== PackageManager.PERMISSION_DENIED){

                  System.out.println("permistion denied");
                  result.success(false);
               }else{
                   System.out.println("permistion granted");
                   result.success(true);
               }
            }
        });
        super.configureFlutterEngine(flutterEngine);




    }

    private void requestpermsion() {

        if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE) ){
           ActivityCompat.requestPermissions(MainActivity.this,new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},100);
            // new   AlertDialog.Builder(this)
            //         .setTitle("Accept a Permission")
            //         .setMessage("Read permission is required to Read  file , please Allow the permission to continued")
            //         .setPositiveButton("Ok", new DialogInterface.OnClickListener() {
            //             @Override
            //             public void onClick(DialogInterface dialog, int which) {
                            
            //             }
            //         })
            //         .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            //             @Override
            //             public void onClick(DialogInterface dialog, int which) {
            //                 dialog.dismiss();
            //             }
            //         }).create().show();
        }else {
            ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},100);
        }

    }

}
