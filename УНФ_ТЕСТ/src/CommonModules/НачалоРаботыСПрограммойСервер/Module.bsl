#Область ПрограммныйИнтерфейс

// Добавляет необходимые параметры работы клиента при запуске.
//
// Параметры:
//	Параметры - Структура - заполняемые параметры;
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПоказатьОкноНачалоРаботыСПрограммой = НЕ ЗначениеЗаполнено(Константы.ДатаПервогоВходаВСистему.Получить());
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		ПоказатьОкноНачалоРаботыСПрограммой = (ПоказатьОкноНачалоРаботыСПрограммой И Пользователи.ЭтоПолноправныйПользователь());
		
	КонецЕсли;
	
	Параметры.Вставить("ПоказатьОкноНачалоРаботыСПрограммой", ПоказатьОкноНачалоРаботыСПрограммой);
	
КонецПроцедуры

// Регистрирует обработчики поставляемых данных
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "Константа.ДатаПервогоВходаВСистему";
	Обработчик.КодОбработчика = 01;
	Обработчик.Обработчик = НачалоРаботыСПрограммойСервер;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "Константа.ДатаПервогоВходаВСистему" Тогда
		
		Загружать = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт 
	
КонецПроцедуры

// Функция возвращает значение дополнительного параметра
// параметр используется только для целей отладки
Функция ЗначениеДополнительногоПараметра() Экспорт
	
	Возврат ВРЕГ("#NotToBeSet");
	
КонецФункции // ЗначениеДополнительногоПараметра()

Процедура УстановитьСтандартныйИнтерфейс(ИмяПользователя = Неопределено) Экспорт
	
	Если (МобильноеПриложениеВызовСервера.ЕстьОграничениеМобильногоУНФ()
		И НЕ МобильноеПриложениеВызовСервера.ЕстьПробныйПериод())
		ИЛИ (МобильноеПриложениеВызовСервера.ЕстьОграничениеМобильногоУНФ20()
		И НЕ МобильноеПриложениеВызовСервера.ЕстьПробныйПериод()) Тогда
		МобильноеПриложениеВызовСервера.ПередНачаломРаботыКлиента();
	Иначе
		
		Если ИмяПользователя = Неопределено Тогда
		
			ТекущийПользователь = Пользователи.АвторизованныйПользователь();
			
			УстановитьПривилегированныйРежим(Истина);
			ПрочитанныеСвойства = Пользователи.СвойстваПользователяИБ(ТекущийПользователь.ИдентификаторПользователяИБ);
			УстановитьПривилегированныйРежим(Ложь);
			
			Если ПрочитанныеСвойства <> Неопределено Тогда
				
				ИмяПользователя = ПрочитанныеСвойства.Имя;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Лево = Новый ГруппаНастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		Лево.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельИнструментов"));
		Лево.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельРазделов"));
		Лево.Добавить(Новый ЭлементНастройкиСоставаИнтерфейсаКлиентскогоПриложения("ПанельОткрытых"));
		
		НастройкиСостава = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
		НастройкиСостава.Лево.Добавить(Лево);
		
		Настройки = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
		Настройки.УстановитьСостав(НастройкиСостава);
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения", "", Настройки, , ИмяПользователя);
		
		СоставФорм = Новый СоставФормНачальнойСтраницы;
		СоставФорм.ЛеваяКолонка.Добавить("Обработка.БыстрыйСтартЗагрузкаИзExcel.Форма.Форма");
		СоставФорм.ЛеваяКолонка.Добавить("Обработка.БыстрыеДействия.Форма.БыстрыеДействия");
		СоставФорм.ЛеваяКолонка.Добавить("Обработка.ПульсБизнеса.Форма.ПульсБизнеса");
		СоставФорм.ПраваяКолонка.Добавить("Обработка.ИнформационныйЦентр.Форма.ИнформационныйЦентр");
		СоставФорм.ПраваяКолонка.Добавить("Обработка.ТекущиеДела.Форма");

		НачальнаяСтраница = Новый НастройкиНачальнойСтраницы;
		НачальнаяСтраница.УстановитьСоставФорм(СоставФорм);

		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы", "", НачальнаяСтраница, , ИмяПользователя);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьНастройкиНачальнойСтраницы(НачальнаяСтраница)
	
	ПараметрыКлиента = СтандартныеПодсистемыСервер.ПараметрыКлиентаНаСервере();
	Если ПараметрыКлиента.Получить("СкрытьРабочийСтолПриНачалеРаботыСистемы") = Истина Тогда
		// В БСП форма на рабочем столе уже подменена.
		// Поэтому запишем форму для начала работы в настройки, из которых БСП будет восстанавливать эту форму
		СохраняемыеНастройки = Новый ХранилищеЗначения(НачальнаяСтраница);
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницыПередОчисткой", "", СохраняемыеНастройки);
	Иначе
		ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиНачальнойСтраницы", "", НачальнаяСтраница);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьИнтерфейсНачалаРаботы(ИмяФормы = "") Экспорт
	
	Настройки = Новый НастройкиИнтерфейсаКлиентскогоПриложения;
	НастройкиСостава = Новый НастройкиСоставаИнтерфейсаКлиентскогоПриложения;
	Настройки.УстановитьСостав(НастройкиСостава);
	ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиИнтерфейсаКлиентскогоПриложения", "", Настройки);
	
	Если ПустаяСтрока(ИмяФормы) Тогда
		
		ИмяФормы = "Обработка.НачалоРаботыСПрограммой.Форма";
		
	КонецЕсли;
	
	НачальнаяСтраница = Новый НастройкиНачальнойСтраницы;
	СоставФорм = Новый СоставФормНачальнойСтраницы;
	СоставФорм.ЛеваяКолонка.Добавить(ИмяФормы);
	НачальнаяСтраница.УстановитьСоставФорм(СоставФорм);
	
	СохранитьНастройкиНачальнойСтраницы(НачальнаяСтраница);
	
КонецПроцедуры

#КонецОбласти
