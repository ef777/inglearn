import 'package:csc_picker_i18n/csc_picker.dart';
import 'package:english_learn/model/ulkelermodel.dart';
import 'package:english_learn/pages/auth_pages/login_page.dart';
import 'package:english_learn/service/country.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:quickalert/quickalert.dart';

import '../../service/register_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
      GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
 String? selectedUlkeId;
  String? selectedCityId;
 String ? selectedulke;
  String ? alankodu;
  String ? selectedsehir;
  String? phoneErrorMessage;
  String? passwordErrorMessage;
  String? minLengtError;
  final _formKey = GlobalKey<FormState>();
 String selectedLevel = "A1";
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  TextEditingController surnameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  //TextEditingController levelController = TextEditingController();

  TextEditingController emailController = TextEditingController();
 // TextEditingController cityController = TextEditingController();
 // TextEditingController countryController = TextEditingController();
  TextEditingController identyController = TextEditingController();
 // TextEditingController zipCodeController = TextEditingController();
  //TextEditingController addressController = TextEditingController();


                ///print newly selected country state and city in Text Widge
                ///
                ///
              @override
 
 List <Ulke> ? ulkelerim;
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Kayıt Ol"),
      ),
      body: 
      
      Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/image/img_register.png")),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ad giriniz';
                      }
                      if (value.length < 3) {
                        return 'En az 3 karakter olmalıdır';
                      }
                      if (value.length > 30) {
                        return 'En fazla 30 karakter olmalıdır';
                      }
                      // Sadece harfler ve boşluk karakterlerine izin ver
                      String pattern = r'^[a-zA-ZğüşıöçĞÜŞİÖÇ ]+$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Sadece harf kullanılabilir';
                      }
                      return null;
                    },
                    controller: nameController,
                    title: "Ad",
                  ),
                ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bir Soyad giriniz';
                    }      if (value.length < 3) {
                        return 'En az 3 karakter olmalıdır';
                      }
                      if (value.length > 30) {
                        return 'En fazla 30 karakter olmalıdır';
                      }
                    // Sadece harfler ve boşluk karakterlerine izin ver
                    String pattern = r'^[a-zA-ZğüşıöçĞÜŞİÖÇ ]+$';
                    RegExp regExp = RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return 'Sadece harf kullanılabilir';
                    }
                    return null;
                  },
                  controller: surnameController,
                  title: "Soyad",
                ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bir Kullanıcı adı giriniz';
                    }
                    if (value.length < 2) {
                      return 'En az 2 karakter olmalıdır';
                    }
                    if (value.length > 30) {
                      return 'En fazla 30 karakter olmalıdır';
                    }
                    
                    return null;
                        
                  },
                  controller: userNameController,
                  title: "Kullanıcı Adı",
                ),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bir e-posta adresi giriniz';
                    }
                    if (value.length < 5) {
                      return 'En az 5 karakter olmalıdır';
                    }
                    if (value.length > 30) {
                      return 'En fazla 30 karakter olmalıdır';
                    }
                    // E-posta formatını doğrulama düzenli ifadesi
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return 'Geçerli bir e-posta adresi giriniz';
                    }
                    return null; // Eğer hata yoksa null dön
                  },
                  controller: emailController,
                  title: "E posta",
                ),
                GestureDetector(
                  onTap: () {
                    _showLevelPicker(context);
                  },
                  child:
 inglevelselector(
  
              controller: TextEditingController(text: selectedLevel),
              title: "İngilizce Seviyesi Seç",
            ),
                ),

             /*   CustomTextField(
                  controller: levelController,
                  title: "İngilizce Seviyesi (a1-a2-b1-b2-c1)",
                ), */
                CustomTextField(
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Numara giriniz';
                    }
                    if (value.length != 11 ) {
                      return 'numara 11 karakter olmalıdır';
                    }
                    if (value.length == 11) {
                      return null;
                    }
                    return null;
                  },
                  hintText: "05521234567",
                  maxLength: 11,
                  errorText: phoneErrorMessage,
                  onChanged: (value) {
                    //String pattern = r'(\ 0)?5[0-9]{9}$';
                   // String pattern = r'^(\+?0|\+?90|0)?5[0-9]{9}$';
                  String pattern = r'^0[0-9]{10}$';

                    RegExp regExp = RegExp(pattern);
                    if (value.length == 11 && !regExp.hasMatch(value)) {
                      print(value);
                      setState(() {
                        phoneErrorMessage =
                            'Geçerli bir Türkiye telefon numarası girin';
                      });
                    }
                    // if (value.length == 11 && !regExp.hasMatch(value)) {
                    //   setState(() {
                    //     phoneErrorMessage =
                    //         'Geçerli bir Türkiye telefon numarası girin';
                    //   });
                    // } else {
                    //   setState(() {
                    //     phoneErrorMessage = null; // Hata mesajını temizle
                    //   });
                    // }
                  },
                  controller: telController,
                  title: "Telefon",
                ),
              
                /* CustomTextField(
                  enable: false ,
                  controller: countryController,
                  title: "Adres",
                ), */
                 
              /*  CustomTextField(
                  controller: cityController,
                  title: "Şehir",
                ),*/
                // SelectState(
                //   // style: TextStyle(color: Colors.red),
                //   onCountryChanged: (value) {
                //     setState(() {
                //       countryValue = value;
                //     });
                //   },
                //   onStateChanged: (value) {
                //     setState(() {
                //       stateValue = value;
                //     });
                //   },
                //   onCityChanged: (value) {
                //     setState(() {
                //       cityValue = value;
                //     });
                //   },
                // ),
                 FutureBuilder<List<Ulke>>(
        future: Ulkelergetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Hata: ${snapshot.error}"),
            );
          }
          if (snapshot.hasData) {
            ulkelerim = snapshot.data;
            return Column( children: [
             Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: Material(
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(.1),
          child:  DropdownButtonFormField<String>(
            style:  TextStyle(color: Colors.black,fontSize: 15),
            value: selectedUlkeId,
            onChanged: (value) {
              setState(() {
                selectedUlkeId = value;
                selectedCityId = null; // Ülke değiştiğinde şehir seçimini sıfırla
              selectedulke = ulkelerim!
                    .firstWhere((ulke) => ulke.id == value).baslik;
                    alankodu = ulkelerim!
                    .firstWhere((ulke) => ulke.id == value).alankodu;
                
              });
              print("ülke adi  " + selectedulke!);
            },
             
            items: ulkelerim!.map((ulke) {
              return DropdownMenuItem<String>(
                value: ulke.id,
                child: Text(ulke.baslik!),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Ülke',
            ),
          ),
      ),
    ),

          SizedBox(height: 16),
        Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: Material(
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(.1),
          child:  DropdownButtonFormField<String>(
            style:  TextStyle(color: Colors.black,fontSize: 15),
            value: selectedCityId,
            onChanged: (value) {
              print( value);
              setState(() {

                selectedCityId = value;
                 selectedsehir = ulkelerim!
                    .firstWhere((ulke) => ulke.id == selectedUlkeId).cities!.firstWhere((city) => city.id == value).baslik;
               });
 print(selectedsehir);
            },
            items: selectedUlkeId != null
                ? ulkelerim!
                    .firstWhere((ulke) => ulke.id == selectedUlkeId)
                    .cities!
                    .map((city) {
                    return DropdownMenuItem<String>(
                      value: city.id,
                      child: Text(city.baslik!),
                    );
                  }).toList()
                : [],
            decoration: InputDecoration(
              labelText: 'Şehir',
            ),
          ),
      ))
            ]);
          }
          return Container();
        },
                 ),
          SizedBox(height: 16),
        
       
               
                CustomTextField(
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bir Parola giriniz';
                    }
                    if (value.length < 8) {
                      return 'En az 8 karakter olmalıdır';
                    }
                    
                    if (value.length > 30) {
                      return 'En fazla 30 karakter olmalıdır';
                    }
                   
                    return null;
                  },
                  onChanged: (value) {
                    passwordController.text = value;
                    /* print (passwordController.text);
                       if (passwordController.text !=
                        passwordAgainController.text) {
                          print( passwordController.text + " " + passwordAgainController.text);
                           passwordErrorMessage =
                            "Parola aynı olmak zorunda";
                     /* setState(() {
                       
                      }); */
                    } */
                    if (passwordController.text ==
                        passwordAgainController.text) {
                           passwordErrorMessage = null;
                        print("Parola aynı");
                       /* setState(() {
                       
                      }); */
                    }
                  },
                  isSec: true,
                  controller: passwordController,
                  title: "Parola",
                                    errorText: passwordErrorMessage,

                ), 
 
            
                CustomTextField(
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bir Parola giriniz';
                    }
                    if (value.length < 8) {
                      return 'En az 8 karakter olmalıdır';
                    }
                    if (value.length > 30) {
                      return 'En fazla 30 karakter olmalıdır';
                    }
                    if (passwordController.text != passwordAgainController.text) {
                      return 'Parolalar aynı olmak zorunda';
                    }
                   
                   
                    return null;
                  },

                  onChanged: (value) {
                   passwordAgainController.text = value;
                                    //    print (passwordAgainController.text);

                    /*if (passwordController.text !=
                        passwordAgainController.text) {
                          print( passwordController.text + " " + passwordAgainController.text);
                          print("Parolalar aynı değil");
                           passwordErrorMessage =
                            "Parolalar aynı olmak zorunda";
                     /* setState(() {
                       
                      }); */
                    } */
                    if (passwordController.text ==
                        passwordAgainController.text) {
                            /* setState(() {
                       
                      }); */
                    passwordErrorMessage = null;
                        print("Parolalar aynı");
                    }
                  },
                  errorText: passwordErrorMessage,
                  isSec: true,
                  controller: passwordAgainController,
                  title: "Parola Tekrarı",
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: CustomButton(
                    title: "Kayıt Ol",
                    onPressed: () {
                    
                          if (selectedulke != "" && selectedsehir.isNotNullOrNoEmpty 
                           
                          ) {
                       
print("ülkeler boş değil");
print("ülke: " + selectedulke!);
                      if (_formKey.currentState!.validate()) {
                      
                        // Form geçerliyse burada bir sonraki işlemi gerçekleştirin
                        registerService(
                                username: userNameController.text,
                                level: selectedLevel,
                                tel: telController.text,
                                name: nameController.text,
                                surname: surnameController.text,
                                email: emailController.text,
                                passwd: passwordController.text,
                                passwdAgain: passwordAgainController.text,
                                age: ageController.text,
                                address: "$selectedsehir - $selectedulke",
                                city: selectedsehir,
                                country: selectedulke, 
                                identifyNumber: identyController.text,
                                zipcode: alankodu)
                            .then((value) {
                          if (value.isRegister ?? false) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title: "Başarılı",
                              text: "Üye Olundu",
                              confirmBtnText: "Giriş Yap",
                              onConfirmBtnTap: () =>
                                  context.navigateToPage(const LoginPage()),
                            );
                          } else {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: "Başarısız",
                              text: "Üye Kaydı Başarısız",
                              confirmBtnText: "Tamam",
                            );
                          }
                        });
                      }
                   
                        }
                        else {
 showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Hata"),
                                content: Text("Ülke ve şehir seçiniz"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Tamam"),
                                  ),
                                ],
                              );
                            });
                        }
  
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )
       
      
     
    );
  }
  void _showLevelPicker(BuildContext context) async {
    String result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("İngilizce Seviyesi Seç"),
          content: Column(
            children: [
              ListTile(
                title: Text("A1"),
                onTap: () {
                  Navigator.pop(context, "A1");
                },
              ),
              ListTile(
                title: Text("A2"),
                onTap: () {
                  Navigator.pop(context, "A2");
                },
              ),
              ListTile(
                title: Text("B1"),
                onTap: () {
                  Navigator.pop(context, "B1");
                },
              ),
              ListTile(
                title: Text("B2"),
                onTap: () {
                  Navigator.pop(context, "B2");
                },
              ),
              ListTile(
                title: Text("C1"),
                onTap: () {
                  Navigator.pop(context, "C1");
                },
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedLevel = result;
      });
    }
  }
}



class inglevelselector extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool enabled;

  inglevelselector({
    required this.controller,
    required this.title,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(.1),
          child:  TextFormField(
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      
                      return 'Seviye Seçiniz';
                    }
                  
                    return null;
                  },
      controller: controller,
      decoration: InputDecoration(
        
        labelText: title,
        suffixIcon: Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: enabled ? Colors.black : Colors.grey)
      ),
      enabled: false,
            style: TextStyle(color: enabled ? Colors.black : Colors.grey),

    )
      ),
    );

  }
  }
  


  