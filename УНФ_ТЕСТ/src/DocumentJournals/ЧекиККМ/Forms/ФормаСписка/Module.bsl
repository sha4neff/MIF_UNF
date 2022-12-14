///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(ЧекиККМ, "КассаККМ", КассаККМ, ЗначениеЗаполнено(КассаККМ), ВидСравненияКомпоновкиДанных.Равно);
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(ЧекиККМ, "КассоваяСмена", ТекущийОтчетОРозничныхПродажах, ТолькоТекущаяСмена, ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры // УстановитьОтборДинамическихСписков()

// Процедура - обработчик события "ПриИзменении" поля "КассаККМ".
//
&НаСервере
Процедура КассаККМОтборПриИзмененииНаСервере()
	
	ОбновитьСостояниеКассовойСменыНаСервере(КассаККМ);
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры // КассаОтборПриИзмененииНаСервере()

// Процедура - обработчик события "ПриИзменении" поля "КассаККМ" на сервере.
//
&НаКлиенте
Процедура КассаККМОтборПриИзменении(Элемент)
	
	КассаККМОтборПриИзмененииНаСервере();
	
КонецПроцедуры // КассаОтборПриИзменении()

// Функция выполняет открытие кассовой смены на сервере.
//
&НаСервереБезКонтекста
Функция ОткрытьКассовуюСменуНаСервере(КассаККМ, ОписаниеОшибки = "", ТекстПереходящегоОстатка = "")
	
	Результат = РозничныеПродажиСервер.ОткрытьКассовуюСмену(КассаККМ, ОписаниеОшибки, ТекстПереходящегоОстатка);
	Возврат Результат;
	
КонецФункции // ОткрытьКассовуюСменуНаСервере()

// Процедуру необходимо вызывать с клиента при открытии кассовой смены
&НаСервере
Процедура ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ)
	
	ОбновитьСостояниеКассовойСменыНаСервере(КассаККМ);
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры // ОбновитьСостояниеКассовойСменыНаСервере()

// Процедура - обработчик команды "ОткрытьКассовуюСмену".
//
&НаКлиенте
Процедура ОткрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(КассаККМ) Тогда
		ТекстОшибки = НСтр("ru='Выберите кассу ККМ!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, ,"КассаККМ");
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	
	ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
	ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
	ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КассаККМ", КассаККМ);
	ДополнительныеПараметры.Вставить("СтруктурнаяЕдиница", ПараметрыКассыККМ.СтруктурнаяЕдиница);
	ДополнительныеПараметры.Вставить("Организация", ПараметрыКассыККМ.Организация);
	
	Если ИспользоватьПодключаемоеОборудование И НЕ ИспользоватьБезПодключенияОборудования И ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		ЭтаФорма.Доступность = Ложь;
		
		ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыОткрытияЗакрытияСмены();
		РеквизитыКассира = РозничныеПродажиСервер.ПолучитьРеквизитыКассира(ПользователиКлиент.ТекущийПользователь());
		Если РеквизитыКассира.ИмяКассираИДолжность <> "" Тогда
			ПараметрыОперации.Кассир = РеквизитыКассира.ИмяКассираИДолжность;
			ПараметрыОперации.КассирИНН = РеквизитыКассира.КассирИНН;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьКассовуюСменуЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьОткрытиеСменыНаФискальномУстройстве(
			Оповещение,
			УникальныйИдентификатор,
			ПараметрыОперации,
			ИдентификаторУстройства,
			,
			ДополнительныеПараметры
		);
		
	Иначе
		Результат = ОткрытьКассовуюСменуНаСервере(КассаККМ, ОписаниеОшибки);
		Если НЕ Результат Тогда
			ТекстСообщения = НСтр("ru = 'При открытии смены произошла ошибка.
			                            |Смена не открыта.
			                            |Дополнительное описание:
			                            |%ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКассовуюСменуЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтаФорма.Доступность = Истина;
	Если РезультатВыполнения.Результат Тогда 
		ОписаниеОшибки = "";
		Результат = ОткрытьКассовуюСменуНаСервере(КассаККМ, ОписаниеОшибки); 
		Если НЕ Результат Тогда
			ТекстСообщения = НСтр("ru = 'При открытии смены произошла ошибка. Смена не открыта.
							       |Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
	Иначе
		ТекстСообщения = НСтр("ru = 'При открытии смены произошла ошибка.
			                      |Смена не открыта на фискальном регистраторе.
			                      |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды "ЗакрытьКассовуюСмену".
//
&НаКлиенте
Процедура ЗакрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(КассаККМ) Тогда
		ТекстОшибки = НСтр("ru='Выберите кассу ККМ!'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстОшибки,
			,
			"КассаККМ"
		);
		
		Возврат;
	КонецЕсли;
	
	ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
	Если Не ПараметрыКассыККМ.СоздаватьВыемку Тогда
		ЗакрытьКассовуюСменуПродолжение(Истина, Новый Структура);
	Иначе
		Оповещение = Новый ОписаниеОповещения("ЗакрытьКассовуюСменуПродолжение", ЭтотОбъект);
		ВыемкаДенег(Неопределено, ПараметрыКассыККМ, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьКассовуюСменуПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
	ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
	ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	
	Если ИспользоватьБезПодключенияОборудования Тогда
		СформироватьОтчетОРозничныхПродажах(ИспользоватьБезПодключенияОборудования);
	ИначеЕсли ИспользоватьПодключаемоеОборудование И ЗначениеЗаполнено(ИдентификаторУстройства) Тогда
		
		ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыОткрытияЗакрытияСмены();
		РеквизитыКассира = РозничныеПродажиСервер.ПолучитьРеквизитыКассира(ПользователиКлиент.ТекущийПользователь());
		Если РеквизитыКассира.ИмяКассираИДолжность <> "" Тогда
			ПараметрыОперации.Кассир = РеквизитыКассира.ИмяКассираИДолжность;
			ПараметрыОперации.КассирИНН = РеквизитыКассира.КассирИНН;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ПечатьФискальногоОтчетаЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(
			Оповещение, 
			УникальныйИдентификатор,
			ПараметрыОперации,
			ИдентификаторУстройства, 
			,
			ТекущаяКассоваяСмена
		);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассовыеСмены(Команда)
	
	ОткрытьФорму("Документ.КассоваяСмена.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура КорректировочныеЧеки(Команда)
	
	ОткрытьФорму("Документ.ЧекККМКоррекции.ФормаСписка");
	
КонецПроцедуры

// Процедура - обработчик команды "СформироватьОтчетОРозничныхПродажах".
//
&НаКлиенте
Процедура СформироватьОтчетОРозничныхПродажах(ИспользоватьБезПодключенияОборудования) Экспорт
	
	// 1. Заполнение отчета о розничных продажах.
	ДлительнаяОперация = НачатьФормированиеОтчетаОРозничныхПродажах(КассаККМ);
	
	глОперацияЗакрытияКассовойСмены = ДлительнаяОперация;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется закрытие смены'");
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ПриЗавершенииФормированияОтчетаОРозничныхПродажах", ЭтотОбъект, ИспользоватьБезПодключенияОборудования);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьФормированиеОтчетаОРозничныхПродажах(КассаККМ)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		"Документы.ОтчетОРозничныхПродажах.СформироватьОтчетОРозничныхПродажахИВыполнитьАрхивацию",
		КассаККМ);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииФормированияОтчетаОРозничныхПродажах(Результат, ДополнительныеПараметры) Экспорт
	
	глОперацияЗакрытияКассовойСмены = Неопределено;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ИспользоватьБезПодключенияОборудования = ДополнительныеПараметры;
	
	СтруктураРезультата	= ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	ОписаниеОшибки		= СтруктураРезультата.ОписаниеОшибки;
	Документ			= СтруктураРезультата.ОтчетОРозничныхПродажах;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки)
	   И ИспользоватьБезПодключенияОборудования Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеОшибки);
	ИначеЕсли ЗначениеЗаполнено(ОписаниеОшибки)
		 И НЕ ИспользоватьБезПодключенияОборудования Тогда
		ТекстСообщения = НСтр(
			"ru = 'При формировании отчета о розничных продажах возникли ошибки.
			|Дополнительное описание:
			|%ДополнительноеОписание%'"
		);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	// 2. Заполнение параметров кассовой смены.
	Результат = ЗакрытьКассовуюСменуНаСервере(КассаККМ, ОписаниеОшибки); 
	Если НЕ Результат Тогда
		ТекстСообщения = НСтр("ru = 'При закрытии смены произошла ошибка.
		                            |Смена не закрыта.
		                            |Дополнительное описание:
		                            |%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	// Все результирующие документы выводим пользователю.
	Если Документ <> Неопределено Тогда
		ОткрытьФорму("Документ.ОтчетОРозничныхПродажах.ФормаОбъекта", Новый Структура("Ключ", Документ));
	КонецЕсли;
	
	ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
	Оповестить("ОбновитьФормыПослеСнятияZОтчета");
	
КонецПроцедуры

&НаСервере
Функция ЗакрытьКассовуюСменуНаСервере(КассаККМ, ОписаниеОшибки, СсылкаНаОтчет = Неопределено)
	
	Возврат РозничныеПродажиСервер.ЗакрытьКассовуюСмену(КассаККМ, ОписаниеОшибки, СсылкаНаОтчет);
	
КонецФункции

&НаКлиенте
Процедура ПечатьФискальногоОтчетаЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтаФорма.Доступность = Истина; // Разблокировка интерфейса пользователя.
	
	Если РезультатВыполнения.Результат Тогда
		СформироватьОтчетОРозничныхПродажах(Ложь);
	Иначе
		ТекстСообщения = НСтр(
			"ru = 'При закрытии смены на фискальном регистраторе произошла ошибка.
			|""%ОписаниеОшибки%""
			|Отчет на фискальном регистраторе не сформирован.'"
		);
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ОписаниеОшибки%",
			РезультатВыполнения.ОписаниеОшибки
		);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
		Оповестить("ОбновитьФормыПослеСнятияZОтчета");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды "ВнесениеДенег".
//
&НаКлиенте
Процедура ВнесениеДенег(Команда)
	
	ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
	ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	
	Если ИспользоватьБезПодключенияОборудования Тогда
		ОткрытьФормуДляВыбораРасходаИзКассы(Истина);
	ИначеЕсли МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		ОткрытьФормуДляВыбораРасходаИзКассы(Ложь);
	Иначе
		ТекстСообщения = НСтр("ru = 'Предварительно необходимо выбрать рабочее место внешнего оборудования текущего сеанса.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик команды "ВнесениеДенег".
//
&НаКлиенте
Процедура ВнесениеДенегЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено И ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВносимаяСумма = ?(Результат = Неопределено, ДополнительныеПараметры.ВносимаяСумма, Результат);
	
	Если (Результат <> Неопределено) Тогда
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
		ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
		ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
		
		ЭтаФорма.Доступность = Ложь; // Блокируем интерфейс пользователя.
		
		Если ИдентификаторУстройства <> Неопределено Тогда
			ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыИнкассации();
			ПараметрыОперации.ТипИнкассации = 1;
			ПараметрыОперации.Сумма = ВносимаяСумма;
			ОповещениеПриЗавершении = Новый ОписаниеОповещения("ИнкассацияНаФискальномУстройствеЗавершение", ЭтотОбъект);
			МенеджерОборудованияКлиент.НачатьИнкассациюНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации, ИдентификаторУстройства);
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры // ВнесениеДенег()

&НаКлиенте
Процедура ИнкассацияНаФискальномУстройствеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтаФорма.Доступность = Истина; // Разблокировка интерфейса пользователя.
	
	Если НЕ РезультатВыполнения.Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка.
			                        |Чек не напечатан на фискальном устройстве.
			                        |Дополнительное описание: %ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", РезультатВыполнения.ОписаниеОшибки);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
	Если Параметры <> Неопределено И Параметры.Свойство("СоздатьВыемкуНаличных") И Параметры.СоздатьВыемкуНаличных Тогда
		
		ДополнительныеПараметры = Новый Структура("ИзымаемаяСумма", Параметры.Сумма);
		
		Если Параметры.Свойство("ОповещениеЗакрытияСмены") Тогда
			ДополнительныеПараметры.Вставить("ОповещениеЗакрытияСмены", Параметры.ОповещениеЗакрытияСмены);
		КонецЕсли;
		
		Если Параметры.Свойство("ОповещениеПоступленияВКассу") Тогда
			ДополнительныеПараметры.Вставить("ОповещениеПоступленияВКассу", Параметры.ОповещениеПоступленияВКассу);
		КонецЕсли;
		
		СформироватьДокументВыемки(Параметры.Сумма, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РассчитатьСуммуВыемки(СтруктураСостояниеКассовойСмены, ПараметрыКассыККМ);
	
	СуммаВыемки = Макс(СтруктураСостояниеКассовойСмены.НаличностьВКассе - ПараметрыКассыККМ.МинимальныйОстатокВКассеККМ, 0);
	
	Возврат СуммаВыемки;
	
КонецФункции

// Процедура - обработчик команды "ИзъятиеДенег".
//
&НаКлиенте
Процедура ВыемкаДенег(Команда, ПараметрыКассыККМ = Неопределено, ОповещениеЗакрытияСмены = Неопределено)
	
	Если ПараметрыКассыККМ = Неопределено Тогда
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
	КонецЕсли;
	
	ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	
	ИзымаемаяСумма = РассчитатьСуммуВыемки(СтруктураСостояниеКассовойСмены, ПараметрыКассыККМ);
	ЗаголовокОкна = НСтр("ru='Сумма выемки, %Валюта%'");
	ЗаголовокОкна = СтрЗаменить(
		ЗаголовокОкна,
		"%Валюта%",
		СтруктураСостояниеКассовойСмены.ВалютаДокументаПредставление
	);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИзымаемаяСумма", ИзымаемаяСумма);
	ДополнительныеПараметры.Вставить("ОповещениеЗакрытияСмены", ОповещениеЗакрытияСмены);
	Если ОповещениеЗакрытияСмены <> Неопределено И ПараметрыКассыККМ.СоздаватьПоступлениеВКассу Тогда
		ОповещениеПоступленияВКассу = Новый ОписаниеОповещения("СоздатьПоступлениеВКассу", ЭтотОбъект, ПараметрыКассыККМ.КассаДляРозничнойВыручки);
		ДополнительныеПараметры.Вставить("ОповещениеПоступленияВКассу", ОповещениеПоступленияВКассу);
	КонецЕсли;
	
	Если ИспользоватьБезПодключенияОборудования Тогда
		ПоказатьВводЧисла(Новый ОписаниеОповещения("СформироватьДокументВыемки", ЭтотОбъект, ДополнительныеПараметры), ИзымаемаяСумма, ЗаголовокОкна, 15, 2);
	ИначеЕсли МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		ПоказатьВводЧисла(Новый ОписаниеОповещения("ВыемкаДенегЗавершение", ЭтотОбъект, ДополнительныеПараметры), ИзымаемаяСумма, ЗаголовокОкна, 15, 2);
	Иначе
		ТекстСообщения = НСтр("ru = 'Предварительно необходимо выбрать рабочее место внешнего оборудования текущего сеанса.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры // ВыемкаДенег()

&НаКлиенте
Процедура СоздатьПоступлениеВКассу(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоступлениеВКассу = СоздатьПоступениеВКассуНаСервере(Результат, ДополнительныеПараметры);
	
	Если ПоступлениеВКассу <> Неопределено Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Создан документ'"),
									   ПолучитьНавигационнуюСсылку(ПоступлениеВКассу), ПоступлениеВКассу);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьПоступениеВКассуНаСервере(Основание, Касса)
	
	ЕстьПравоЧтения = ПравоДоступа("Чтение", Метаданные.Документы.ПоступлениеВКассу, Пользователи.ТекущийПользователь());
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПоступлениеВКассу = Документы.ПоступлениеВКассу.СоздатьДокумент();
	
	ПоступлениеВКассу.Заполнить(Основание);
	ПоступлениеВКассу.Касса = Касса;
	ПоступлениеВКассу.Дата = ТекущаяДатаСеанса();
	ПоступлениеВКассу.Записать(РежимЗаписиДокумента.Проведение);
	
	Если ЕстьПравоЧтения Тогда
		Возврат ПоступлениеВКассу.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Процедура - обработчик команды "ИзъятиеДенег".
//
&НаКлиенте
Процедура ВыемкаДенегЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ИзымаемаяСумма = ?(Результат = Неопределено, ДополнительныеПараметры.ИзымаемаяСумма, Результат);
	
	Если (Результат <> Неопределено) И (Результат <> 0) Тогда
		
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
		ИдентификаторУстройства = ПараметрыКассыККМ.ИдентификаторУстройства;
		ИспользоватьБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
		
		ЭтаФорма.Доступность = Ложь; // Блокируем интерфейс пользователя.
		
		Если ИдентификаторУстройства <> Неопределено Тогда
			ПараметрыОперации = МенеджерОборудованияКлиентСервер.ПараметрыИнкассации();
			ПараметрыОперации.ТипИнкассации = 0;
			ПараметрыОперации.Сумма = ИзымаемаяСумма;
			ПараметрыОповещения = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ПараметрыОперации);
			ПараметрыОповещения.Вставить("СоздатьВыемкуНаличных", Истина);
			Если ДополнительныеПараметры.Свойство("ОповещениеЗакрытияСмены") Тогда
				ПараметрыОповещения.Вставить("ОповещениеЗакрытияСмены", ДополнительныеПараметры.ОповещениеЗакрытияСмены);
			КонецЕсли;
			Если ДополнительныеПараметры.Свойство("ОповещениеПоступленияВКассу") Тогда
				ПараметрыОповещения.Вставить("ОповещениеПоступленияВКассу", ДополнительныеПараметры.ОповещениеПоступленияВКассу);
			КонецЕсли;
			ОповещениеПриЗавершении = Новый ОписаниеОповещения("ИнкассацияНаФискальномУстройствеЗавершение", ЭтотОбъект, ПараметрыОповещения);
			МенеджерОборудованияКлиент.НачатьИнкассациюНаФискальномУстройстве(ОповещениеПриЗавершении, УникальныйИдентификатор, ПараметрыОперации, ИдентификаторУстройства);
		КонецЕсли;
		
	Иначе
		
		Если ДополнительныеПараметры.Свойство("ОповещениеЗакрытияСмены") И ДополнительныеПараметры.ОповещениеЗакрытияСмены <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗакрытияСмены, Результат);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ВыемкаДенегЗавершение()

&НаКлиенте
Процедура ЗавершитьВыбораКассыПриОткрытииДенежногоЯщика(ЗначениеВыбораКасса)
	
	Если НЕ ЗначениеЗаполнено(ЗначениеВыбораКасса) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(ЗначениеВыбораКасса);
	ИдентификаторУстройстваФР = ПараметрыКассыККМ.ИдентификаторУстройства;
	
	ИспользоватьКассуККМБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	
	Если ИспользоватьПодключаемоеОборудование И НЕ ИспользоватьКассуККМБезПодключенияОборудования Тогда
		Оповещение = Новый ОписаниеОповещения("ЗавершитьВыбораКассыПриОткрытииДенежногоЯщикаЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьОткрытиеДенежногоЯщика(Оповещение, ЭтотОбъект, ИдентификаторУстройстваФР, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОткрытьФормуВыбораКассыПриОткрытииДенежногоЯщика(РезультатОткрытияФормы, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатОткрытияФормы = Неопределено И ТипЗнч(РезультатОткрытияФормы) = Тип("Структура") Тогда
		ЗначениеВыбораКасса = РезультатОткрытияФормы.Касса;
		ЗавершитьВыбораКассыПриОткрытииДенежногоЯщика(ЗначениеВыбораКасса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДенежныйЯщик(Команда)
	
	Если Не ИспользоватьПодключаемоеОборудование Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Денежный ящик не может быть открыт."),
																	НСтр("ru = 'Подключаемое оборудование не используется.'"));
		Возврат;
	КонецЕсли;
	
	Если МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		ОбработчикОповещения = Новый ОписаниеОповещения("ОповещениеОткрытьФормуВыбораКассыПриОткрытииДенежногоЯщика", ЭтотОбъект);
		ЗначениеВыбораКасса = КассаККМ; //ВыбраннаяКассаККМ(ОбработчикОповещения);
		ЗавершитьВыбораКассыПриОткрытииДенежногоЯщика(ЗначениеВыбораКасса);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Устройство для печати чеков не подключено.'"))
	КонецЕсли;
	
КонецПроцедуры

// Функция выполняет получение состояния кассовой смены на сервере.
//
&НаСервереБезКонтекста
Функция ПолучитьСостояниеКассовойСменыНаСервере(КассаККМ)
	
	Возврат РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(КассаККМ);
	
КонецФункции // ПолучитьСостояниеКассовойСменыНаСервере()

// Процедура выполняет обновление состояния кассовой смены на клиенте.
//
&НаСервере
Процедура ОбновитьСостояниеКассовойСменыНаСервере(КассаККМ)
	
	СтруктураСостояниеКассовойСмены = ПолучитьСостояниеКассовойСменыНаСервере(КассаККМ);
	
	Если ЗначениеЗаполнено(СтруктураСостояниеКассовойСмены.СтатусКассовойСмены) Тогда
		
		ТекстСообщения = НСтр("ru='Смена № %НомерСмены%, Статус: %СтатусСмены% %ВремяИзменения%, В кассе %НаличностьВКассе% %Валюта%'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСмены%", СокрЛП(СтруктураСостояниеКассовойСмены.НомерКассовойСмены));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусСмены%", СтруктураСостояниеКассовойСмены.СтатусКассовойСмены);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НаличностьВКассе%", СтруктураСостояниеКассовойСмены.НаличностьВКассе);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", СтруктураСостояниеКассовойСмены.ВалютаДокументаПредставление);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВремяИзменения%", Формат(СтруктураСостояниеКассовойСмены.ДатаИзмененияСтатуса,"ДФ='dd.MM.yy ЧЧ:мм'"));
		
		СостояниеКассовойСмены = ТекстСообщения;
		
	Иначе
		
		СостояниеКассовойСмены = НСтр("ru='Смена не открыта.'");
		
	КонецЕсли;
	
	// Переменная формы
	СменаОткрыта = СтруктураСостояниеКассовойСмены.СменаОткрыта;
	ТекущаяКассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
	ТекущийОтчетОРозничныхПродажах = СтруктураСостояниеКассовойСмены.ОтчетОРозничныхПродажах;
	
	// Управление доступностью.
	Если РежимПросмотра Тогда
		
		Элементы.СнятьZОтчет.Видимость		  = Ложь;
		Элементы.ОткрытьКассовуюСмену.Видимость = Ложь;
		
		Элементы.ЧекиККМСоздатьЧек.Доступность					= Ложь;
		Элементы.КонтекстноеМенюЧекиККМСоздать.Доступность		= Ложь;
		
		Элементы.ВнесениеДенег.Доступность = Ложь;
		Элементы.ВыемкаДенег.Доступность   = Ложь;
		
	Иначе

		Элементы.СнятьZОтчет.Видимость		  = СменаОткрыта;
		Элементы.ОткрытьКассовуюСмену.Видимость = НЕ СменаОткрыта И ЗначениеЗаполнено(КассаККМ);
		
		Элементы.ЧекиККМСоздатьЧек.Доступность					= СменаОткрыта;
		Элементы.КонтекстноеМенюЧекиККМСоздать.Доступность		= СменаОткрыта;
		Элементы.ЧекиККМДокументЧекККМВозвратСоздатьНаОсновании.Доступность = СменаОткрыта;
		Элементы.ЧекиККМСкопировать.Доступность				= СменаОткрыта;
		Элементы.КонтекстноеМенюЧекиККМСкопировать.Доступность = СменаОткрыта;
		
		Элементы.ВнесениеДенег.Доступность = СменаОткрыта;
		Элементы.ВыемкаДенег.Доступность   = СменаОткрыта;
	
	КонецЕсли;
	
КонецПроцедуры // ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков()

// Процедура - обработчик команды "ОбновитьСостояниеКассовойСмены".
//
&НаКлиенте
Процедура ОбновитьСостояниеКассовойСмены(Команда)
	
	Если НЕ ЗначениеЗаполнено(КассаККМ) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
	
КонецПроцедуры // ОбновитьСостояниеКассовойСмены()

// Процедура - обработчик события "ОбработкаОповещения" формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия  = "ОбновитьФормыПослеСнятияZОтчета" Тогда
		Элементы.ЧекиККМ.Обновить();
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
		ЧекиККМПриАктивизацииСтрокиНаКлиенте();
	ИначеЕсли ИмяСобытия = "ОбновитьФормуСпискаДокументовЧекККМ" Тогда
		Элементы.ЧекиККМ.Обновить();
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
		ЧекиККМПриАктивизацииСтрокиНаКлиенте();
	ИначеЕсли ИмяСобытия = "ОбновитьФормыПослеЗакрытияКассовойСмены" Тогда
		Элементы.ЧекиККМ.Обновить();
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
		ЧекиККМПриАктивизацииСтрокиНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

// Процедура предназначается для обработки события "ПриАктивизацииСтроки" списка ЧекиККМ
//
&НаКлиенте
Процедура ЧекиККМПриАктивизацииСтрокиНаКлиенте()
	
	Если СтруктураСостояниеКассовойСмены = Неопределено Тогда
		ОбновитьСостояниеКассовойСменыИУстановитьОтборДинамическихСписков(КассаККМ);
	КонецЕсли;
	
	Если РежимПросмотра Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ЧекиККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если НЕ ТекущиеДанные.Свойство("ГруппировкаСтроки")
			И ЗначениеЗаполнено(ТекущиеДанные.НомерЧекаККМ)
			И ЗначениеЗаполнено(СтруктураСостояниеКассовойСмены)
			И НЕ ТекущиеДанные.ЕстьЧекНаВозврат
			И СменаОткрыта
			И ТекущиеДанные.Тип <> Тип("ДокументСсылка.ЧекККМВозврат") Тогда
			
			Элементы.ЧекиККМДокументЧекККМВозвратСоздатьНаОсновании.Доступность = Истина;
			Элементы.КонтекстноеМенюЧекиККМДокументЧекККМВозвратСоздатьНаОсновании.Доступность = Истина;
			
		Иначе
			
			Элементы.ЧекиККМДокументЧекККМВозвратСоздатьНаОсновании.Доступность = Ложь;
			Элементы.КонтекстноеМенюЧекиККМДокументЧекККМВозвратСоздатьНаОсновании.Доступность = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ЧекиККМПриАктивизацииСтрокиНаКлиенте()

// Процедура - обработчик события "ПриАктивизацииСтроки" списка ЧекиККМ.
//
&НаКлиенте
Процедура ЧекиККМПриАктивизацииСтроки(Элемент)
	
	ЧекиККМПриАктивизацииСтрокиНаКлиенте();
	
КонецПроцедуры // ЧекиККМПриАктивизацииСтроки()

// Процедура предназначается для обработки события "ПриИзмененииНаСервере" флага ТолькоТекущаяСменаОтбор на сервере
//
&НаСервере
Процедура ТолькоТекущаяСменаОтборПриИзмененииНаСервере()
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры // ТолькоТекущаяСменаОтборПриИзмененииНаСервере()

// Процедура - обработчик события "ПриИзменении" флага ТолькоТекущаяСменаОтбор.
//
&НаКлиенте
Процедура ТолькоТекущаяСменаОтборПриИзменении(Элемент)

	ТолькоТекущаяСменаОтборПриИзмененииНаСервере();

КонецПроцедуры // ТолькоТекущаяСменаОтбор()

// Процедура - обработчик команды "СоздатьЧек".
//
&НаКлиенте
Процедура СоздатьЧек(Команда)
	
	Если СменаОткрыта Тогда
		ПараметрыОткрытия = Новый Структура("Основание", Новый Структура("КассаККМ", КассаККМ));
		ОткрытьФорму("Документ.ЧекККМ.ФормаОбъекта", ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры // СоздатьЧек()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	
	РежимПросмотра = Не ПравоДоступа("Редактирование", Метаданные.Документы.ЧекККМ);
	
	// КассаККМ по умолчанию
	// Определим, сохранялись ли настройки ранее.
	ПользовательСсылка = Пользователи.АвторизованныйПользователь();
	Если НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		ПользовательСсылка = Справочники.Пользователи.ПустаяСсылка();
		ПользовательИнформационнойБазы = "";
	Иначе
		ПользовательИнформационнойБазы = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательСсылка);
	КонецЕсли;
	Отбор = Новый Структура("Пользователь, КлючОбъекта", ПользовательИнформационнойБазы, "ЖурналДокументов.ЧекиККМ.Форма.ФормаСписка/КлючТекущихНастроекДанных");
	
	
	Если Параметры.Свойство("КассаККМ") И ЗначениеЗаполнено(Параметры.КассаККМ) Тогда
		КассаККМ = Параметры.КассаККМ;
		КассаККМИзПараметров = Параметры.КассаККМ;
		КассаККМОтборПриИзмененииНаСервере();
	Иначе
		ВыборкаНастроек = ХранилищеСистемныхНастроек.Выбрать(Отбор);
		
		Если НЕ ВыборкаНастроек.Следующий() Тогда
			// Если не сохранялись, то установим отбор по основной кассе. Иначе отработает обработчик "ПриЗагрузкеДанныхИзНастроекНаСервере".
			КассаККМ = Справочники.КассыККМ.ПолучитьКассуККМПоУмолчанию(Перечисления.ТипыКассККМ.ФискальныйРегистратор);
			
			Если НЕ КассаККМ.Пустая() Тогда
				КассаККМОтборПриИзмененииНаСервере();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	// Конец КассаККМ по умолчанию
	
	// Заказы покупателей в Рознице
	Элементы.ЕстьЗаказы.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыВРозничнойТорговле");
	Элементы.Заказ.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыВРозничнойТорговле");
	Элементы.Покупатель.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыВРозничнойТорговле");
	// Конец Заказы покупателей в Рознице
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(ЧекиККМ);
	
	ЭтоМобильныйКлиент = УправлениеНебольшойФирмойСервер.ЭтоМобильныйКлиент();
	Если ЭтоМобильныйКлиент Тогда
		Если Параметры.Свойство("ЭтоРМК_МК") И Параметры.ЭтоРМК_МК Тогда
			Элементы.ЧекиККМ.ИспользованиеТекущейСтроки = ИспользованиеТекущейСтрокиТаблицы.ОтображениеВыделения;
		КонецЕсли;
		Элементы.УправлениеОборудованием_МК.Видимость = Истина;
		Элементы.УправлениеОборудованием.Видимость = Ложь;
	Иначе
		Элементы.УправлениеОборудованием_МК.Видимость = Ложь;
		Элементы.УправлениеОборудованием.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗагрузкеДанныхИзНастроекНаСервере" формы.
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если НЕ (Параметры.Свойство("КассаККМ") И ЗначениеЗаполнено(Параметры.КассаККМ)) Тогда
		КассаККМ = Настройки.Получить("КассаККМ");
		
		// Нужно учесть, что RLS могли измениться и касса, которая раньше была доступна,
		// теперь может стать недоступной.
		Если ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей") Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	КассыККМ.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.КассыККМ КАК КассыККМ
				|ГДЕ
				|	КассыККМ.Ссылка = &КассаККМ";
			
			Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
			
			РезультатЗапроса = Запрос.Выполнить();
			Если РезультатЗапроса.Пустой() Тогда
				КассаККМ = Справочники.КассыККМ.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
		ТолькоТекущаяСмена = Настройки.Получить("ТолькоТекущаяСмена");
		КассаККМОтборПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормыЧекККМ");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормыЧекККМ");
	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(КассаККМИзПараметров) Тогда
		КассаККМ = КассаККМИзПараметров;
	КонецЕсли;
	
	Если глОперацияЗакрытияКассовойСмены <> Неопределено Тогда
		ДлительнаяОперация = глОперацияЗакрытияКассовойСмены;
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется закрытие смены'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры


// Процедура - обработчик команды ПечатьТоварногоЧека формы
//
&НаКлиенте
Процедура ПечатьТоварногоЧека(Команда)
	РозничныеПродажиКлиент.НапечататьТоварныйЧек(ЭтотОбъект,, "ЧекиККМ");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДляВыбораРасходаИзКассы(БезПодключения = Истина)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Касса", КассаККМ);
	
	Если БезПодключения Тогда
		ОткрытьФорму("Документ.РасходИзКассы.Форма.ФормаВнесенияНаличных",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОткрытьФорму("Документ.РасходИзКассы.Форма.ФормаВнесенияНаличных",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ВнесениеДенегЗавершение", ЭтотОбъект),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументВыемки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат <> 0 Тогда
		
		ДокументВыемка = СформироватьДокументВыемкиНаСервере(Результат, ДополнительныеПараметры.ИзымаемаяСумма);
		
		Если ДокументВыемка <> Неопределено Тогда
			ПоказатьОповещениеПользователя(НСтр("ru = 'Создан документ'"),
										   ПолучитьНавигационнуюСсылку(ДокументВыемка), ДокументВыемка);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеПоступленияВКассу") И ДополнительныеПараметры.ОповещениеПоступленияВКассу <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПоступленияВКассу, ДокументВыемка);
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ОповещениеЗакрытияСмены") И ДополнительныеПараметры.ОповещениеЗакрытияСмены <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗакрытияСмены, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьДокументВыемкиНаСервере(Результат, ИзымаемаяСумма)
	
	СуммаДокумента = ?(Результат = Неопределено, ИзымаемаяСумма, Результат);
	
	Если Результат <> Неопределено Тогда
		
		ПараметрыКассыККМ = УправлениеНебольшойФирмойПовтИсп.ПолучитьПараметрыКассыККМ(КассаККМ);
		
		ДокументВыемка = Документы.ВыемкаНаличных.СоздатьДокумент();
		СтруктураЗаполнения = Новый Структура;
		СтруктураЗаполнения.Вставить("Дата", ТекущаяДатаСеанса());
		СтруктураЗаполнения.Вставить("СуммаДокумента", СуммаДокумента);
		СтруктураЗаполнения.Вставить("КассаККМ", КассаККМ);
		СтруктураЗаполнения.Вставить("ВалютаДенежныхСредств", КассаККМ.ВалютаДенежныхСредств);
		СтруктураЗаполнения.Вставить("Организация", КассаККМ.Владелец);
		СтруктураЗаполнения.Вставить("ОтчетОРозничныхПродажах", СтруктураСостояниеКассовойСмены.ОтчетОРозничныхПродажах);
		ДокументВыемка.Заполнить(СтруктураЗаполнения);
		ДокументВыемка.Записать(РежимЗаписиДокумента.Проведение);
		
		Возврат ДокументВыемка.Ссылка;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура УправлениеФискальнымУстройством(Команда)
	
	ОткрытьФорму("ОбщаяФорма.УправлениеФискальнымУстройством_УНФ",, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
