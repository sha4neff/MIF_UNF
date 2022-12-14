#Область ОбработчикиСобытийФормы
//

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы
// 
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для каждого Строка Из Метаданные.ЖурналыДокументов.ДокументыПоЗарплате.РегистрируемыеДокументы Цикл
		Элементы.ОтборТипДокумента.СписокВыбора.Добавить(Строка.Имя, Строка.Синоним);
	КонецЦикла;
	
	списокСотрудник	= Новый Массив;
	Если Параметры <> Неопределено
		И Параметры.Свойство("Сотрудник") Тогда
		
		Сотрудник = Параметры.Сотрудник;
		
		Если ЗначениеЗаполнено(Сотрудник) Тогда
			списокСотрудник.Добавить(Сотрудник);
		КонецЕсли;
		Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", НЕ ЗначениеЗаполнено(списокСотрудник));
		Список.Параметры.УстановитьЗначениеПараметра("списокСотрудник", списокСотрудник);
		
	Иначе
		// установим пустые значения параметров запроса списка
		Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("списокСотрудник", списокСотрудник);
		
		//УНФ.ОтборыСписка
		Если Параметры.Свойство("ЭтоНачальнаяСтраница") Тогда
			РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
			ЭтоНачальнаяСтраница = Ложь;
		Иначе
			ЭтоНачальнаяСтраница = Истина;
			РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Ложь);
			ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Неопределено);
		КонецЕсли;
		//Конец УНФ.ОтборыСписка	
	КонецЕсли;
	
	Если Параметры <> Неопределено
		И Параметры.Свойство("Организация") Тогда
		
		УстановитьМеткуИОтборСписка("Организация", "ГруппаОтборОрганизация", Параметры.Организация);
		
	КонецЕсли;
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	ОтображениеПериодаРегистрации = Формат(ПериодРегистрации, "ДФ='MMMM yyyy'");
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события формы ОбработкаВыбора
//
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ИсточникВыбора) = Тип("ФормаКлиентскогоПриложения")
		И СтрНайти(ИсточникВыбора.ИмяФормы, "ФормаКалендаря") > 0 Тогда
		
		ПериодРегистрации = КонецДня(ВыбранноеЗначение);
		УправлениеНебольшойФирмойКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ПериодРегистрации, ЗначениеЗаполнено(ПериодРегистрации));
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаВыбора()


//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ 
//

&НаКлиенте
// Процедура - обработчик события Регулирования реквизита ПериодРегистрации.
//
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	УправлениеНебольшойФирмойКлиент.ПриРегулированииПериодаРегистрации(ЭтаФорма, Направление);
	УправлениеНебольшойФирмойКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ПериодРегистрации, ЗначениеЗаполнено(ПериодРегистрации));
	
КонецПроцедуры //ПериодРегистрацииРегулирование()

&НаКлиенте
// Процедура - обработчик события НачалоВыбора реквизита ПериодРегистрации.
//
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка	 = Ложь;
	
	ДатаКалендаряПриОткрытии = ?(ЗначениеЗаполнено(ПериодРегистрации), ПериодРегистрации, УправлениеНебольшойФирмойПовтИсп.ПолучитьТекущуюДатаСеанса());
	
	ОткрытьФорму("ОбщаяФорма.ФормаКалендаря", УправлениеНебольшойФирмойКлиент.ПолучитьПараметрыОткрытияФормыКалендаря(ДатаКалендаряПриОткрытии), ЭтаФорма);
	
КонецПроцедуры //ПериодРегистрацииНачалоВыбора()

&НаКлиенте
// Процедура - обработчик события Очистки реквизита ПериодРегистрации.
//
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	ПериодРегистрации = Неопределено;
	УправлениеНебольшойФирмойКлиент.ПриИзмененииПериодаРегистрации(ЭтаФорма);
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ПериодРегистрации", ПериодРегистрации, ЗначениеЗаполнено(ПериодРегистрации));
	
КонецПроцедуры //ПериодРегистрацииОчистка()

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		
		СохранитьНастройкиОтборов();
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ОтборСотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Сотрудник", Элемент.Родитель.Имя, ВыбранноеЗначение, ,"списокСотрудник");
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеОтбора = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;
	ЗначениеТип = ?(ЗначениеЗаполнено(ВыбранноеЗначение), Тип("ДокументСсылка." + ВыбранноеЗначение), Неопределено);

	УстановитьМеткуИОтборСписка("ТипДокумента", Элемент.Родитель.Имя, ЗначениеТип, ПредставлениеОтбора);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура();
	Если ЗначениеЗаполнено(ПериодРегистрации) Тогда
		СтруктураПараметров.Вставить("ПериодРегистрации", ПериодРегистрации);
	КонецЕсли;
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Сотрудник");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "СтруктурнаяЕдиница");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");
		
	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);
	ОткрытьФорму("Документ."+ИмяФормыСтрока+".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));

КонецПроцедуры

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="", ИмяПараметраЗапроса="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения, ,ИмяПараметраЗапроса);
	
	Если ИмяПараметраЗапроса="" Тогда
		РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	Иначе	
		
		СтруктураОтбораМеток = Новый Структура("ИмяПараметраЗапроса", ИмяПараметраЗапроса);
		НайденныеСтроки = ДанныеМеток.НайтиСтроки(СтруктураОтбораМеток);
		МассивОтбора = Новый Массив;
		Для каждого стр Из НайденныеСтроки Цикл
			МассивОтбора.Добавить(стр.Метка);
		КонецЦикла;
		Список.Параметры.УстановитьЗначениеПараметра("БезОтбора", НайденныеСтроки.Количество()=0);
		Список.Параметры.УстановитьЗначениеПараметра(ИмяПараметраЗапроса, МассивОтбора);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	Если НЕ ЭтоНачальнаяСтраница Тогда
		РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти




#КонецОбласти
