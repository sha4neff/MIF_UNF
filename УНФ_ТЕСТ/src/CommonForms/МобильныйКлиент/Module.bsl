#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПереходИзМП20") И Параметры.ПереходИзМП20 Тогда
		Элементы.Группа1.Видимость = Ложь;
		Элементы.ГруппаПереходИзМП.Видимость = Истина;
	Иначе
		Элементы.Группа1.Видимость = Истина;
		Элементы.ГруппаПереходИзМП.Видимость = Ложь;
	КонецЕсли;
	
	//Если МобильноеПриложение20ВызовСервераМПУНФ.ВключенПробныйПериод() Тогда
	//	Элементы.ВернутьсяВМобильноеПриложение20.Видимость = Истина;
	//Иначе
	Элементы.ВернутьсяВМобильноеПриложение20.Видимость = Ложь;
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияQRAndroidНажатие(Элемент)
	
	ПерейтиВGooglePlay();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаAndroidНажатие(Элемент)
	
	ПерейтиВGooglePlay();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияQRiOSНажатие(Элемент)
	
	ПерейтиВAppStore();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКнопкаiOSНажатие(Элемент)
	
	ПерейтиВAppStore();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВернутьсяВМобильноеПриложение20(Команда)
	
	Текст = НСтр("ru = 'При обратном переходе, данные, созданные в пробной версии, не перенесутся в мобильное приложение.
	|Продолжить?'");
	Результат = Неопределено;
	ПоказатьВопрос(Новый ОписаниеОповещения("ВернутьсяВМобильноеПриложение20ПриСогласии", ЭтотОбъект), Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиВGooglePlay()
	
	АдресСтраницы = УправлениеНебольшойФирмойКлиентСервер.ПолучитьАдресПубликацииМобильногоКлиентаВGooglePlay();
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВAppStore()
	
	АдресСтраницы = УправлениеНебольшойФирмойКлиентСервер.ПолучитьАдресПубликацииМобильногоКлиентаВAppStore();
	ПерейтиПоНавигационнойСсылке(АдресСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяВМобильноеПриложение20ПриСогласии(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ВключитьМобильный20ПриСогласииНаСервере();
		МассивПользователей = МобильноеПриложениеВызовСервера.ПолучитьМассивПользователей();
		МобильноеПриложениеВызовСервера.УстановитьМинимальныйИнтерфейс(МассивПользователей);
		МобильноеПриложениеВызовСервера.УстановитьСоставФормДляПользователей(МассивПользователей, Истина);
		ОбновитьИнтерфейс();
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВключитьМобильный20ПриСогласииНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ЭтоМобильноеПриложение20.Установить(Истина);
	Константы.ЭтоОбычноеПриложение.Установить(Ложь);
	Константы.ЭтоМобильноеПриложение.Установить(Ложь);
	Константы.ВключенПробныйПериодМПУНФ.Установить(Ложь);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти