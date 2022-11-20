
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Для Каждого Устройство Из Устройства Цикл
		
		УстойствоОбъект = Устройство.ПолучитьОбъект();
		УстойствоОбъект.ПравилоОбмена = ПравилоОбмена;
		УстойствоОбъект.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтчетОРозничныхПродажахПоКассе(КассаККМ, ДатаЗагрузки)
	
	Отчет = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетОРозничныхПродажах.Ссылка КАК Отчет
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.КассаККМ = &КассаККМ
	|	И ОтчетОРозничныхПродажах.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания");
	
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	Запрос.УстановитьПараметр("ДатаНачала",    ДатаЗагрузки - 5);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаЗагрузки + 5);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Отчет = Выборка.Отчет;
	КонецЕсли;
	
	Возврат Отчет;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	Весы.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	КассыККМ.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СкладККМOffline = Настройки.Получить("СкладККМOffline");
	СкладВесы = Настройки.Получить("СкладВесы");
	
	ПравилоОбменаВесы = Настройки.Получить("ПравилоОбменаВесы");
	ПравилоОбменаККМOffline = Настройки.Получить("ПравилоОбменаККМOffline");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "Склад", СкладККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладККМOffline));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПравилоОбмена", ПравилоОбменаККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаККМOffline));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "Склад", СкладВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладВесы));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПравилоОбмена", ПравилоОбменаВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаВесы));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеВесы = Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеККМOffline = Ложь);
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененоРабочееМестоТекущегоСеанса" Тогда
		
		РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
		
		Весы.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
		КассыККМ.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
		
	ИначеЕсли ИмяСобытия = "Запись_ПравилаОбменаСПодключаемымОборудованиемOffline"
		ИЛИ ИмяСобытия = "Запись_КодыТоваровПодключаемогоОборудования" Тогда
		
		Элементы.Весы.Обновить();
		Элементы.КассыККМ.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура ВесыПосмотретьСписокТоваров(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПараметрыФормы = Новый Структура("Устройство, ПравилоОбмена", ТекущиеДанные.ПодключаемоеОборудование, ТекущиеДанные.ПравилоОбмена);
		ОткрытьФорму("РегистрСведений.КодыТоваровPLUНаОборудовании.ФормаСписка", ПараметрыФормы, УникальныйИдентификатор);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыНазначитьПравилоДляВыделенных(Команда)
	
	Устройства = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.Весы.ВыделенныеСтроки Цикл
		Устройства.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если Устройства.Количество() > 0 Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипПодключаемогоОборудования", ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток"));
		Оповещение = Новый ОписаниеОповещения("ВесыНазначитьПравилоДляВыделенныхЗавершение",ЭтаФорма,Устройства);
		ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ФормаВыбора", ПараметрыОткрытия, УникальныйИдентификатор,,,,Оповещение);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыНазначитьПравилоДляВыделенныхЗавершение(ПравилоОбмена,Устройства) Экспорт
	
	Если ЗначениеЗаполнено(ПравилоОбмена) Тогда
		НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена);
	КонецЕсли;
		
	Элементы.Весы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыВыгрузить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВесыТоварыВыгрузитьЗавершение", ЭтотОбъект, Новый Структура("РеквизитФормы", "ФайлЗагрузки"));
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыВыгрузитьЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОповещениеОВыполнении = Новый ОписаниеОповещения(
		"ВесыТоварыОбменВесамиOfflineЗавершение",
		ЭтотОбъект
	);
	
	ПодключаемоеОборудованиеOfflineКлиент.АсинхронныйВыгрузитьТоварыВОборудованиеOffline(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток"), Элементы.Весы.ВыделенныеСтроки,,, ОповещениеОВыполнении, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыОбменВесамиOfflineЗавершение(Результат, Параметры) Экспорт
	
	Если Результат Тогда
		Элементы.Весы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыОчистить(Команда)
	
	ОповещениеОВыполнении = Новый ОписаниеОповещения(
		"ВесыТоварыОбменВесамиOfflineЗавершение",
		ЭтотОбъект
	);
	
	ПодключаемоеОборудованиеOfflineКлиент.АсинхронныйОчиститьТоварыВОборудованиеOffline(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток"), Элементы.Весы.ВыделенныеСтроки,,, ОповещениеОВыполнении);
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыПерезагрузить(Команда)
	
	ОповещениеОВыполнении = Новый ОписаниеОповещения(
		"ВесыТоварыОбменВесамиOfflineЗавершение",
		ЭтотОбъект
	);
	
	ПодключаемоеОборудованиеOfflineКлиент.АсинхронныйВыгрузитьТоварыВОборудованиеOffline(ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток"), Элементы.Весы.ВыделенныеСтроки,,, ОповещениеОВыполнении, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыПосмотретьСписокТоваров(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПараметрыФормы = Новый Структура("Устройство, ПравилоОбмена", ТекущиеДанные.ПодключаемоеОборудование, ТекущиеДанные.ПравилоОбмена);
		ОткрытьФорму("РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline.ФормаСписка", ПараметрыФормы, УникальныйИдентификатор);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыНазначитьПравилоДляВыделенных(Команда)
	
	Устройства = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.КассыККМ.ВыделенныеСтроки Цикл
		Устройства.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если Устройства.Количество() > 0 Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипПодключаемогоОборудования", ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМОфлайн"));
		Оповещение = Новый ОписаниеОповещения("КассыНазначитьПравилоДляВыделенныхЗавершение",ЭтаФорма,Устройства);
		ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ФормаВыбора", ПараметрыОткрытия, УникальныйИдентификатор,,,,Оповещение);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыНазначитьПравилоДляВыделенныхЗавершение(ПравилоОбмена,Устройства) Экспорт
	
	Если ЗначениеЗаполнено(ПравилоОбмена) Тогда
		НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена);
	КонецЕсли;
		
	Элементы.КассыККМ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыВыгрузить(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыТоварыОбменСККМOfflineЗавершение",
			ЭтотОбъект
		);
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыОбменСККМOfflineЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ОписаниеОшибки") Тогда
		ПоказатьПредупреждение(Неопределено, Результат.ОписаниеОшибки, 10);
	КонецЕсли;
	Элементы.КассыККМ.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыОчистить(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыТоварыОбменСККМOfflineЗавершение",
			ЭтотОбъект
		);
		МенеджерОфлайнОборудованияКлиент.НачатьОчисткуПрайсЛистаНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыПерезагрузить(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыТоварыОбменСККМOfflineЗавершение",
			ЭтотОбъект
		);
		МенеджерОфлайнОборудованияКлиент.НачатьПолнуюВыгрузкуПрайсЛистаНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыЗагрузитьОтчетОРозничныхПродажах(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыТоварыОбменСККМOfflineЗавершение",
			ЭтотОбъект
		);
		МенеджерОфлайнОборудованияКлиент.НачатьЗагрузкуДанныхИзККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыОткрытьПравилоОбмена(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПоказатьЗначение(Неопределено,ТекущиеДанные.ПравилоОбмена);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыОткрытьПравилоОбмена(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПоказатьЗначение(Неопределено,ТекущиеДанные.ПравилоОбмена);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическийОбмен(Команда)
	
	ПараметрыФормы = Новый Структура("РабочееМесто", РабочееМесто);
	ОткрытьФорму("ОбщаяФорма.АвтоматическийОбменСПодключаемымОборудованиемOffline", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СкладВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "Склад", СкладВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладВесы));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОбменаВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПравилоОбмена", ПравилоОбменаВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаВесы));
	
КонецПроцедуры

&НаКлиенте
Процедура СкладККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "Склад", СкладККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладККМOffline));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОбменаККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПравилоОбмена", ПравилоОбменаККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаККМOffline));
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КассыККМ.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеККМOffline = Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Весы.Отбор, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеВесы = Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если Поле = Элементы.КассыККМДатаЗагрузки И ЗначениеЗаполнено(ТекущиеДанные.ДатаЗагрузки) Тогда
		СтандартнаяОбработка = Ложь;
		Отчет = ПолучитьОтчетОРозничныхПродажахПоКассе(ТекущиеДанные.КассаККМ, ТекущиеДанные.ДатаЗагрузки);
		
		Если ЗначениеЗаполнено(Отчет) Тогда
			ПоказатьЗначение(Неопределено,Отчет);
		Иначе
			ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Отчет о розничных продажах не найден.'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыВыгрузитьНастройки(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОповещениеОВыполнении = Новый ОписаниеОповещения(
			"КассыТоварыОбменСККМOfflineЗавершение",
			ЭтотОбъект
		);
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуНастроекНаККМ(ТекущиеДанные.ПодключаемоеОборудование, УникальныйИдентификатор, ОповещениеОВыполнении);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчетыЗаПериод(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ЭтоКассаЭвотор = МенеджерОфлайнОборудованияВызовСервера.ПодключаемоеОборудованиеЭвотор(ТекущиеДанные.ПодключаемоеОборудование);
		
		Если ЭтоКассаЭвотор Тогда
			ИдентификаторУстройства = ?(ПустаяСтрока(ТекущиеДанные.ПодключаемоеОборудование), Неопределено, ТекущиеДанные.ПодключаемоеОборудование);
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
			
			ОповещениеПриЗавершении = Новый ОписаниеОповещения("ЗагрузитьОтчетЗаПериодЗавершение", ЭтотОбъект);
			ОткрытьФорму("ОбщаяФорма.ФормаНастройки1СЭвоторККМOfflineПроизвольногоПериодаЗагрузки", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеПриЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			ТекстСообщения = НСтр("ru='Для данного типа устройства данная команда недоступна.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчетЗаПериодЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Если Результат.Результат Тогда
			ТекстСообщения = НСтр("ru='Данные загружены успешно'");
		Иначе
			ТекстСообщения = Результат.ОписаниеОшибки;
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
