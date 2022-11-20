#Область ПроцедурыИФункцииОбщегоНазначения

&НаСервере
Процедура НастроитьЭлементыПоВидуКлиента();
	
	// Видимость элементов в зависимости от клиента.
	Элементы.ОткрытьЖурналЧекиККМ.Видимость = ЭтоМобильныйКилент;
	Элементы.ОткрытьСписокОтчетовОРозничныхПродажах.Видимость = ЭтоМобильныйКилент;
	Элементы.ОткрытьСписокЗаказовПокупателей.Видимость = ЭтоМобильныйКилент;
	Элементы.НеПоказыватьПриОткрытииФормуВыбораКассы.Видимость = Не ЭтоМобильныйКилент;
	Элементы.ВыполнятьСверкуИтогоПриЗакрытииСмены.Видимость = Не ЭтоМобильныйКилент;
	Элементы.НадписьНастройкаОткрытияЭтогоОкна.Видимость = Не ЭтоМобильныйКилент;
	Элементы.КассаККМ.РастягиватьПоГоризонтали = ЭтоМобильныйКилент;
	Элементы.ЭквайринговыйТерминал.РастягиватьПоГоризонтали = ЭтоМобильныйКилент;
	Элементы.ДекорацияОтступ_1.Видимость = Не ЭтоМобильныйКилент;
	
	Если НЕ ЭтоМобильныйКилент Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаОткрытьРабочееМестоКассира.Заголовок = НСтр("ru = 'Новый чек'");
	Элементы.ФормаОткрытьРабочееМестоКассира.Высота = 3;
	
	Элементы.ГруппаКнопкаОткрытияРМК.ВертикальноеПоложениеПодчиненных = ВертикальноеПоложениеЭлемента.Низ;
	Элементы.ГруппаКнопкаОткрытияРМК.РастягиватьПоВертикали = Истина;
	
	Элементы.ГруппаКнопкаОткрытияРМК.РастягиватьПоГоризонтали = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет документ чек ККМ по кассе ККМ.
//
// Параметры
//  ДанныеЗаполнения - Структура со значениями отбора
//
&НаСервере
Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ, ЗначенияЗаполнения = Неопределено)
	
	СостояниеКассовойСмены = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(Объект, СостояниеКассовойСмены);
	
	Если ЭквайринговыйТерминал.Пустая() ИЛИ КассаККМ <> ЭквайринговыйТерминал.Касса Тогда
		ЗаполнитьЭквайринговыйТерминалПоКассе();
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьДокументПоОтбору()

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоМобильныйКилент = УправлениеНебольшойФирмойСервер.ЭтоМобильныйКлиент();
	
	Если Параметры.Свойство("ЗначенияЗаполнения")
		И Параметры.ЗначенияЗаполнения.Свойство("КассаККМ") Тогда
		
		ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	Иначе
		ЗначенияЗаполнения = РабочееМестоКассираВызовСервера.ПолучитьКассуККМИТерминалПоУмолчанию();
	КонецЕсли;
	
	Объект.КассаККМ = ЗначенияЗаполнения.КассаККМ;
	Если Объект.КассаККМ <> Неопределено Тогда
		ЗаполнитьДокументПоКассеККМ(Объект.КассаККМ, ЗначенияЗаполнения);
	КонецЕсли;
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	Если НЕ ЗначениеЗаполнено(РабочееМесто) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось определить рабочее место для работы с подключаемым оборудованием!";
		Сообщение.Сообщить();
	КонецЕсли;
		
	НастройкаРМК = РабочееМестоКассираВызовСервера.ПолучитьНастройкуРМК(РабочееМесто);
	Если Объект.КассаККМ.Пустая() Тогда
		Если Не ЗначениеЗаполнено(НастройкаРМК) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не удалось получить настройки РМК для текущего рабочего места!";
			Сообщение.Сообщить();
		Иначе
			НеПоказыватьПриОткрытииФормуВыбораКассы = НастройкаРМК.НеПоказыватьПриОткрытииФормуВыбораКассы И НЕ ЭтоМобильныйКилент;
			СверятьИтогиНаЭТПриЗакрытииСмены = НастройкаРМК.СверятьИтогиНаЭТПриЗакрытииСмены;
		КонецЕсли;
	Иначе // В справочнике "Кассы ККМ" только один элемент непомеченный на удаление.
		Если ЭтоМобильныйКилент Тогда
			Элементы.КассаККМ.Видимость = Ложь;
		Иначе
			Элементы.КассаККМ.ТолькоПросмотр = Истина;
		КонецЕсли;
		Если ЗначенияЗаполнения.КоличествоЭквайринговыхТерминалов < 2 Тогда
			НеПоказыватьПриОткрытииФормуВыбораКассы = Истина;
			СверятьИтогиНаЭТПриЗакрытииСмены = Ложь;
			Если ЗначенияЗаполнения.КоличествоЭквайринговыхТерминалов = 1 Тогда
				Элементы.ЭквайринговыйТерминал.ТолькоПросмотр = Истина;
			Иначе
				Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
			КонецЕсли;
		Иначе
			НеПоказыватьПриОткрытииФормуВыбораКассы = НастройкаРМК.НеПоказыватьПриОткрытииФормуВыбораКассы И НЕ ЭтоМобильныйКилент;
			СверятьИтогиНаЭТПриЗакрытииСмены = НастройкаРМК.СверятьИтогиНаЭТПриЗакрытииСмены;
		КонецЕсли;
	КонецЕсли;
	
	КассаККМ = Объект.КассаККМ;
	ЭквайринговыйТерминал = Объект.ЭквайринговыйТерминал;
	
	Если Параметры.Свойство("ОткрытаДляПодбора") Тогда
		ОткрытаДляПодбора = Параметры.ОткрытаДляПодбора;
	КонецЕсли;
	
	НастроитьЭлементыПоВидуКлиента();
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НеПоказыватьПриОткрытииФормуВыбораКассы И Не Объект.КассаККМ.Пустая()
		И НЕ ЭтоМобильныйКилент Тогда
		ОткрытьРабочееМестоКассира(Команды.ОткрытьРабочееМестоКассира);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриЗагрузкеДанныхИзНастроекНаСервере.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ТекКассаККМ = Настройки.Получить("КассаККМ");
	Если ЗначениеЗаполнено(ТекКассаККМ) И НЕ ТекКассаККМ.ПометкаУдаления Тогда
		КассаККМ = ТекКассаККМ;
		Объект.КассаККМ = КассаККМ;
	Иначе
		КассаККМ = Объект.КассаККМ;
	КонецЕсли;
	
	ТекЭквайринговыйТерминал = Настройки.Получить("ЭквайринговыйТерминал");
	Если ЗначениеЗаполнено(ТекЭквайринговыйТерминал) И НЕ ТекЭквайринговыйТерминал.ПометкаУдаления
		И ТекЭквайринговыйТерминал.Касса = Объект.КассаККМ Тогда
		ЭквайринговыйТерминал = ТекЭквайринговыйТерминал;
		Объект.ЭквайринговыйТерминал = ЭквайринговыйТерминал;
		ЗаполнитьЭквайринговыйТерминалПоКассе();
	Иначе
		ЭквайринговыйТерминал = Неопределено;
		ЗаполнитьЭквайринговыйТерминалПоКассе();
	КонецЕсли;
	
	СтруктураНастроекДляОткрытияНачальнойСтраницы = Новый Структура("КассаККМ, ЭквайринговыйТерминал",
		Объект.КассаККМ, Объект.ЭквайринговыйТерминал
	);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РМКНаНачальнойСтранице", "РМКНаНачальнойСтранице_ДляНачальнойСтраницы", СтруктураНастроекДляОткрытияНачальнойСтраницы);
	
	ЗаполнитьДокументПоКассеККМ(Объект.КассаККМ);
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьЭквайринговыйТерминалПоКассе()
	
	// Если к кассе привязан один ЭТ, то заполним его.
	ЗначенияЗаполнения = РабочееМестоКассираВызовСервера.ПолучитьТерминалПоУмолчанию(КассаККМ);
	Если ЗначенияЗаполнения.КоличествоЭквайринговыхТерминалов = 1 Тогда
		Если Объект.ЭквайринговыйТерминал.Пустая() Или Объект.ЭквайринговыйТерминал.Владелец <> ЭквайринговыйТерминал.Владелец Тогда
			ЭквайринговыйТерминал = ЗначенияЗаполнения.ЭквайринговыйТерминал;
			Объект.ЭквайринговыйТерминал = ЭквайринговыйТерминал;
		КонецЕсли;
		Если ЭтоМобильныйКилент И Объект.ЭквайринговыйТерминал = ЗначенияЗаполнения.ЭквайринговыйТерминал Тогда
			Элементы.ЭквайринговыйТерминал.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


// Процедура - обработчик события ПриСохраненииДанныхВНастройкахНаСервере.
//
&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Если Не ЗакрываемФормуПослеОткрытияРМК Тогда
		Настройки.Очистить();
	Иначе
		СтруктураНастроекДляОткрытияНачальнойСтраницы = Новый Структура("КассаККМ, ЭквайринговыйТерминал",
			Объект.КассаККМ, Объект.ЭквайринговыйТерминал
		);
		ИмяКлючаОбъекта = "РМКНаНачальнойСтранице";
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяКлючаОбъекта, ИмяКлючаОбъекта+"_ДляНачальнойСтраницы", СтруктураНастроекДляОткрытияНачальнойСтраницы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды ОткрытьРабочееМестоКассира формы.
//
&НаКлиенте
Процедура ОткрытьРабочееМестоКассира(Команда)
	
	Если Объект.КассаККМ.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Выберите рабочее место кассира";
		Сообщение.Поле = "КассаККМ";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ЗакрываемФормуПослеОткрытияРМК = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Объект.Организация);
	ЗначенияЗаполнения.Вставить("КассаККМ", Объект.КассаККМ);
	ЗначенияЗаполнения.Вставить("СтруктурнаяЕдиница", Объект.СтруктурнаяЕдиница);
	ЗначенияЗаполнения.Вставить("ЭквайринговыйТерминал", Объект.ЭквайринговыйТерминал);
	
	РабочееМестоКассираВызовСервера.ОбновитьНастройкиРМК(
	НастройкаРМК,
	НеПоказыватьПриОткрытииФормуВыбораКассы,
	СверятьИтогиНаЭТПриЗакрытииСмены);
	
	Если НЕ ОткрытаДляПодбора Тогда
		ОткрытьФорму(
			"Документ.ЧекККМ.Форма.ФормаДокумента_РМК",
			Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения));
	КонецЕсли;
	
	Если НЕ ЭтоМобильныйКилент Тогда
		НажатаКнопкаНовыйЧек = Истина;
		Закрыть(ЗначенияЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриИзменении элемента КассаККМ формы.
//
&НаКлиенте
Процедура КассаККМПриИзменении(Элемент)
	
	Объект.КассаККМ = КассаККМ;
	Объект.ЭквайринговыйТерминал = Неопределено;
	
	ЗаполнитьДокументПоКассеККМ(Объект.КассаККМ);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении элемента ЭквайринговыйТерминал формы.
//
&НаКлиенте
Процедура ЭквайринговыйТерминалПриИзменении(Элемент)
	
	Объект.ЭквайринговыйТерминал = ЭквайринговыйТерминал;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтчетовОРозничныхПродажах(Команда)
	ОткрытьФормуСОтборомПоКассеККМ("Документ.ОтчетОРозничныхПродажах.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСОтборомПоКассеККМ(ИмяФормы)
	
	Если КассаККМ.Пустая() Тогда
		ПараметрыСпискаОРП = Новый Структура;
	Иначе
		ПараметрыСпискаОРП = Новый Структура("КассаККМ", КассаККМ);
	КонецЕсли;
	ПараметрыСпискаОРП.Вставить("ЭтоРМК_МК", Истина);
	
	ОткрытьФорму(ИмяФормы, ПараметрыСпискаОРП,, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналЧекиККМ(Команда)
	ОткрытьФормуСОтборомПоКассеККМ("ЖурналДокументов.ЧекиККМ.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗаказовПокупателей(Команда)
	ОткрытьФормуСОтборомПоКассеККМ("Документ.ЗаказПокупателя.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не НажатаКнопкаНовыйЧек И Не ЗавершениеРаботы И ОткрытаДляПодбора Тогда
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'РМК открыто на начальной странице. Необходимо выбрать кассу и нажать кнопку ""Новый чек""'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

