-keep class io.flutter.plugin.editing.** { *; }
-keep class androidx.lifecycle.DefaultLifecycleObserver
-keep class com.pauldemarco.flutter_blue.** { *; }
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-keep class com.shockwave.**

-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

-dontwarn org.joda.convert.FromString
-dontwarn org.joda.convert.ToString

-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*